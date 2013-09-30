class @Post extends Minimongoid

  @_collection: new Meteor.Collection 'posts'

  @extract: (text, user) ->
    _.each Addressable.extract(text), (link) ->
      url = link.href
      unless @find {url}
        Posts.insert {url, user_id: user._id}

  @before_save: (attr) ->
    attr.url = cleanUrl attr.url
    attr

  @before_create: (attr) ->
    attr.url = cleanUrl attr.url
    attr.createdAt = new Date().getTime()
    attr.commentsCount = 0
    attr

  @after_save: (post) ->
    post.createSubscription()

    if Meteor.isServer
      HTTP.get post.url, (error, result) ->
        if error
          console.log error
        else
          post.update
            title: extractTitle(result.content)

  @findByUserId: (id) ->
    subscriptions = Subscription.where userId: id
    ids = _.pluck subscriptions, 'postId'
    Post.find _id: {$in: ids}

  @findOrCreateByUrl: (url, userId) ->
    return post if post = Post.first {url}
    return post if post = Post.create {url, userId} and post.isValid()
    throw new Meteor.Error 422, post.error_message()

  createSubscription: ->
    attrs = {@userId, postId: @id}
    Subscription.first(attrs) or Subscription.create(attrs)

  error_message: ->
    msg = ''
    for i in @errors
      for key, value of i
        msg += "#{value}"
    msg

  validate: ->
    @error 'url', 'URL is required.' if _.isEmpty @url
    @error 'url', 'URL must be valid.' unless validateURL @url


@Post._collection.allow
  insert: (userId, doc) ->
    return !! userId
  update: ownsDocument
  remove: ownsDocument


Meteor.methods
  postsCreate: (attrs) ->
    authorize user = Meteor.user()
    userIds = [userId = user._id]
    url = cleanUrl attrs.url
    {comment} = attrs

    post = Post.findOrCreateByUrl url, userId
    comment = Comment.create {userId, comment, postId: post.id}

    _.each extractEmails(attrs.emails), (email) ->
      friend = createUserByEmail email
      subscribe {userId: friend._id, postId: post._id}

      if Meteor.isServer
        Email.send
          to: email
          subject: "#{nameOrEmail(user)} has shared something with you."
          text: Handlebars.templates['share-notification']({comment, post})

    post

  postsSubscribe: (postId) ->
    user = Meteor.user()
    authorize user
    userId = user._id

    subscribe {userId, postId}, yes


createUserByEmail = (email) ->
  return user if user = Meteor.users.findOne {'emails.address': email}
  Meteor.users.find Accounts.createUser({email, password: 'eventually-randomly-generated'})

subscribe = (attrs, destroy = no) ->
  unless subscription = Subscription.first attrs
    Subscription.create attrs
  else
    subscription.destroy() if destroy
    subscription

nameOrEmail = (user) ->
  user.profile?.name or user.emails[0]?.address or 'a friend'

validateURL = (url) ->
  re = /[-a-zA-Z0-9@:%_\+.~#?&//=]{2,256}\.[a-z]{2,4}\b(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?/gi
  re.test url

cleanUrl = (url) ->
  if /^http/.test url then url else "http://#{url}"

extractTitle = (html) ->
  cheerio = Meteor.require('cheerio');
  $ = cheerio.load(html)
  $('head title').text()

extractEmails = (emails) ->
  return emails if emails instanceof Array
  _.compact emails?.split /[\s+,\,+]/