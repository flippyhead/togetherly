class @User extends Minimongoid

  @_collection: Meteor.users

  @current: ->
    User.init(Meteor.user()) if Meteor.userId()

  @createByEmail: (email) ->
    return user if user = @first 'emails.address': email
    @first Accounts.createUser({email, password: 'eventually-randomly-generated'})

  sharePost: (emails, post, comment = '') ->
    _.each extractEmails(emails), (email) =>
      friend = User.createByEmail email
      friend.subscribe post

      comment = Comment.create {userId: @id, postId: post.id, comment}

      if Meteor.isServer
        textAttributes = {
          comment: comment.comment
          salutation: friend.nameOrEmail()
          authorizedPostUrl: friend.authorizedPostUrl(post)
        }

        Email.send
          to: email
          subject: "#{@nameOrEmail()} has shared something with you."
          html: Handlebars.templates['share-notification'](textAttributes)

  email: ->
    if (@emails and @emails.length) then @emails[0].address else ''

  nameOrEmail: ->
    @profile?.name or @email() or 'friend'

  subscribe: (post) ->
    attrs = {userId: @id, postId: post.id}
    Subscription.first(attrs) or Subscription.create(attrs)

  loginToken: ->
    @services.resume?.loginTokens?[0]?.token

  authorizedPostUrl: (post) ->
    Meteor.absoluteUrl "p/#{post.id}/#{@loginToken()}"


if Meteor.isServer
  Accounts.onCreateUser (options, user) ->

    if options.profile?
      user.profile = options.profile

    if facebook = user.services?.facebook
      (user.emails ?= []).push {address: facebook.email, verified: yes}

    if email = user.emails?[0]
      email.verified = true
      user.gravatarImageUrl = Gravatar.imageUrl email.address

    stampedToken = Accounts._generateStampedLoginToken()
    ((user.services.resume = {}).loginTokens = []).push stampedToken

    user


extractEmails = (emails) ->
  return emails if emails instanceof Array
  _.compact emails?.split /[\s+,\,+]/
