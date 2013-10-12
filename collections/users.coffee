class @User extends Minimongoid

  @_collection: Meteor.users

  @current: ->
    User.init(Meteor.user()) if Meteor.userId()

  @createByEmail: (email) ->
    return user if user = @first 'emails.address': email
    @first Accounts.createUser({email, password: 'eventually-randomly-generated'})

  sharePost: (emails, post, comment) ->
    _.each extractEmails(emails), (email) =>
      friend = User.createByEmail email
      friend.subscribe post
      @follow friend

      comment = Comment.create {userId: @id, postId: post.id, comment}

      if Meteor.isServer
        textAttributes = {
          comment: comment.comment
          salutation: friend.name()
          authorizedPostUrl: friend.authorizedPostUrl(post)
        }

        Email.send
          to: email
          subject: "#{@name()} has shared something with you."
          html: Handlebars.templates['share-notification'](textAttributes)

  createFriends: (emails, callback) ->
    _.each extractEmails(emails), (email) =>
      friend = User.createByEmail email
      @follow friend
      callback friend

  inviteFriends: (emails, note) ->
    @createFriends emails, (user) ->
      console.log user

  email: ->
    if (@emails and @emails.length) then @emails[0].address else ''

  name: ->
    if @profile.firstName then @fullName() else extractLocalPart(@email()) or 'friend'

  fullName: ->
    "#{@profile.firstName} #{@profile.lastName}"

  loginToken: ->
    @services.resume?.loginTokens?[0]?.token

  authorizedPostUrl: (post) ->
    Meteor.absoluteUrl "p/#{post.id}/#{@loginToken()}"

  subscribe: (post) ->
    attrs = {userId: @id, postId: post.id}
    Subscription.first(attrs) or Subscription.create(attrs)

  follow: (friend) ->
    attrs = {userId: @id, friendId: friend.id}
    Dyad.first(attrs) or Dyad.create(attrs)


if Meteor.isServer
  Accounts.onCreateUser (options, user) ->

    user.profile = options.profile or {}

    if facebook = user.services?.facebook
      (user.emails ?= []).push {address: facebook.email, verified: yes}
      user.profile.firstName = facebook.first_name
      user.profile.lastName = facebook.last_name

    if email = user.emails?[0]
      email.verified = true
      user.profile.gravatarImageUrl = Gravatar.imageUrl email.address

    stampedToken = Accounts._generateStampedLoginToken()
    ((user.services.resume = {}).loginTokens = []).push stampedToken

    user


Meteor.methods
  usersFollow: (userId) ->
    authorize user = User.current()
    attrs = userId: user._id, friendId: userId

    if dyad = Dyad.first attrs
      dyad.destroy()
    else
      user.follow User.find(userId)

    dyad

  usersInvite: (emails, note) ->
    authorize user = User.current()
    user.inviteFriends emails, note

extractLocalPart = (email) ->
  matches = email.match(/^(.+)@(.+)\.(\w+)$/i)
  matches[1] if matches.length is 4

extractEmails = (emails) ->
  return emails if emails instanceof Array
  _.compact emails?.split /[\s+,\,+]/
