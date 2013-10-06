class UsersRelation extends PublicationRelation

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

  dyadsByUser: (user) ->
    Dyad.find($or: [{userId: user._id}, {friendId: user._id}]).observe
      added: (dyad) =>
        @sub.added 'dyads', dyad._id, dyad
      removed: (dyad) =>
        @sub.removed 'dyads', dyad._id

  user: (id) ->
    Meteor.users.find(_id: id).observe
      added: (user) =>
        @sub.added 'users', user._id, user
        @subscriptionsByUser user
        @dyadsByUser user

Meteor.publish 'user', (id) ->
  (new UsersRelation @).user(id)
  @ready()