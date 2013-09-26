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
    if Meteor.isServer
      HTTP.get post.url, (error, result) ->
        if error
          console.log error
        else
          post.update
            title: extractTitle(result.content)

  @error_message: ->
    msg = ''
    for i in @errors
      for key, value of i
        msg += "#{value}"
    msg

  @findByUserId: (id) ->
    subscriptions = Subscription.where userId: id
    ids = _.pluck subscriptions, 'postId'
    Post.find _id: {$in: ids}

  validate: ->
    @error 'url', 'URL is required.' if _.isEmpty @url
    @error 'url', 'URL must be valid.' unless validateURL @url


@Post._collection.allow
  insert: (userId, doc) ->
    return !! userId
  update: ownsDocument
  remove: ownsDocument


Meteor.methods
  postsCreate: (postAttributes) ->
    user = Meteor.user()
    userId = user._id
    url = cleanUrl postAttributes.url

    throw new Meteor.Error 401, "You need to login to post new stories" if not user

    unless post = Post.first {url}
      post = Post.create {url}

    postId =  post.id
    if Subscription.count({userId, postId}) < 1
      Subscription.create {userId, postId}

    throw new Meteor.Error 422, Post.error_message() unless post

    post


validateURL = (url) ->
  re = /[-a-zA-Z0-9@:%_\+.~#?&//=]{2,256}\.[a-z]{2,4}\b(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?/gi
  re.test url

cleanUrl = (url) ->
  if /^http/.test url then url else "http://#{url}"

extractTitle = (html) ->
  cheerio = Meteor.require('cheerio');
  $ = cheerio.load(html)
  $('head title').text()
