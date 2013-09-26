Meteor.publish 'posts', (limit) ->

  publishUser = (id) =>
    Meteor.users.find({_id: id}).observe
      added: (user) =>
        @added 'users', user._id, user

  publishSubscriptions = (post) =>
    Subscription.find({postId: post._id}).observe
      added: (subscription) =>
        publishUser subscription.userId
        @added 'subscriptions', subscription._id, subscription

  Post.find({}, {limit}).observe
    added: (post) =>
      @added 'posts', post._id, post
      publishSubscriptions post
      publishUser post.userId
    changed: (post) =>
      @changed 'posts', post._id, post

  @ready()

Meteor.publish 'user', (id) ->

  publishPosts = (subscription) =>
    Post.find(_id: subscription.postId).observe
      added: (post) =>
        @added 'posts', post._id, post

  publishSubscriptions = (user) =>
    Subscription.find({userId: user._id}).observe
      added: (subscription) =>
        @added 'subscriptions', subscription._id, subscription
        publishPosts subscription

  Meteor.users.find(_id: id).observe
    added: (user) =>
      @added 'users', user._id, user
      publishSubscriptions user

  @ready()

Meteor.publish 'comments', -> Comment.find()