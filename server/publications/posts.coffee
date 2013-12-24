class PostsRelation extends PublicationRelation

  user: (id) ->
    Meteor.users.find({_id: id}).observe
      added: (user) =>
        @sub.added 'users', user._id, user

  commentsByPost: (post) ->
    Comment.find({postId: post._id}).observe
      added: (comment) =>
        @user comment.userId
        @sub.added 'comments', comment._id, comment
      removed: (comment) =>
        @sub.removed 'comments', comment._id

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
        @commentsByPost post
      changed: (post) =>
        @sub.changed 'posts', post._id, post

  subscriptionsByUser: (user, limit = 999) ->
    Subscription.find({userId: user._id}, {limit}).observe
      added: (subscription) =>
        @sub.added 'subscriptions', subscription._id, subscription
        @postsBySubscription subscription, limit
      removed: (subscription) =>
        @removed 'subscriptions', subscription._id

  postsBySubscription: (subscription, limit = 999) ->
    Post.find({_id: subscription.postId}, {limit}).observe
      added: (post) =>
        @sub.added 'posts', post._id, post
      removed: (post) =>
        @sub.removed 'posts', post._id

  friendsPosts: (limit = 999) ->
    Dyad.find({userId: @sub.userId}, {limit}).observe
      added: (dyad) =>
        @sub.added 'dyads', dyad._id, dyad
        @user dyad.friendId
        friend = Meteor.users.findOne({_id: dyad.friendId})
        @subscriptionsByUser friend, limit
      removed: (dyad) =>
        @sub.removed 'dyads', dyad._id


Meteor.publish 'postsAll', (limit) ->
  (new PostsRelation @).postsAll(limit)
  @ready()

Meteor.publish 'post', (id) ->
  (new PostsRelation @).post(id)
  @ready()

Meteor.publish 'friendsPosts', (limit) ->
  (new PostsRelation @).friendsPosts(limit)
  @ready()
