class PostsRelation extends PublicationRelation

  user: (id) ->
    Meteor.users.find({_id: id}).observe
      added: (user) =>
        @sub.added 'users', user._id, user

  subscriptionsByPost: (post) ->
    Subscription.find({postId: post._id}).observe
      added: (subscription) =>
        @user subscription.userId
        @sub.added 'subscriptions', subscription._id, subscription
      removed: (subscription) =>
        @sub.removed 'subscriptions', subscription._id

  postsAll: (limit) ->
    Post.find({}, {limit}).observe
      added: (post) =>
        @sub.added 'posts', post._id, post
        @user post.userId
        @subscriptionsByPost post
      changed: (post) =>
        @sub.changed 'posts', post._id, post

  post: (id) ->
    Post.find({_id: id}).observe
      added: (post) =>
        @sub.added 'posts', post._id, post
        @user post.userId
        @subscriptionsByPost post
      changed: (post) =>
        @sub.changed 'posts', post._id, post

  subscriptionsByUser: (user) ->
    Subscription.find({userId: user._id}).observe
      added: (subscription) =>
        @sub.added 'subscriptions', subscription._id, subscription
        @postsBySubscription subscription
      removed: (subscription) =>
        @removed 'subscriptions', subscription._id

  postsBySubscription: (subscription) ->
    Post.find(_id: subscription.postId).observe
      added: (post) =>
        @sub.added 'posts', post._id, post
      removed: (post) =>
        @sub.removed 'posts', post._id

  friendsPosts: ->
    Dyad.find({userId: @sub.userId}).observe
      added: (dyad) =>
        @sub.added 'dyads', dyad._id, dyad
        friend = @user dyad.friendId
        @subscriptionsByUser friend
      removed: (dyad) =>
        @sub.removed 'dyads', dyad._id


Meteor.publish 'postsAll', (limit) ->
  (new PostsRelation @).postsAll(limit)
  @ready()

Meteor.publish 'post', (id) ->
  (new PostsRelation @).post(id)
  @ready()

Meteor.publish 'friendsPosts', ->
  (new PostsRelation @).friendsPosts()
  @ready()
