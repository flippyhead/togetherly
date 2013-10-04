class @Post extends Minimongoid

  @_collection: new Meteor.Collection 'posts'

  @before_save: (attr) ->
    attr.url = cleanUrl attr.url
    attr

  @before_create: (attr) ->
    attr.url = cleanUrl attr.url
    attr.createdAt = new Date().getTime()
    attr.commentsCount = 0
    attr

  @after_save: (post) ->
    post.subscribe User.find(@userId)

    if Meteor.isServer
      HTTP.get post.url, (error, result) ->
        if error
          console.log error
        else
          post.update
            title: extractTitle(result.content)

  @extract: (text, user) ->
    _.each Addressable.extract(text), (link) ->
      url = link.href
      unless @find {url}
        Posts.insert {url, user_id: user._id}

  @findByUserId: (id) ->
    subscriptions = Subscription.where userId: id
    ids = _.pluck subscriptions, 'postId'
    Post.find _id: {$in: ids}

  @findOrCreateByUrl: (url, userId) ->
    url = cleanUrl url
    return post if post = Post.first {url}

    post = Post.create {url, userId}
    throw new Meteor.Error 422, post.error_message() unless post.isValid()
    post

  subscribe: (user) ->
    attrs = {userId: user.id, postId: @id}
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
    authorize user = User.current()
    {comment, emails, url, postId} = attrs

    post = if postId
      Post.find postId
    else
      Post.findOrCreateByUrl url, user.id

    user.subscribe post
    user.sharePost emails, post, comment

    post

  postsSubscribe: (postId) ->
    authorize user = User.current()
    attrs = userId: user.id, postId: postId

    if subscription = Subscription.first attrs
      subscription.destroy()
    else
      user.subscribe Post.find(postId)

    subscription



validateURL = (url) ->
  re = /[-a-zA-Z0-9@:%_\+.~#?&//=]{2,256}\.[a-z]{2,4}\b(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?/gi
  re.test url

cleanUrl = (url) ->
  if /^http/.test url then url else "http://#{url}"

extractTitle = (html) ->
  cheerio = Meteor.require('cheerio');
  $ = cheerio.load(html)
  $('head title').text()

