class UsersRelation extends PublicationRelation

  subscriptionsByUser: (user) ->
    Subscription.find({userId: user._id}).observe
      added: (subscription) =>
        @sub.added 'subscriptions', subscription._id, subscription
        @postsBySubscription subscription
      removed: (subscription) =>
        @sub.removed 'subscriptions', subscription._id

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
      removed: (user) =>
        @sub.removed 'users', user._id

  friends: (userId) ->
    Meteor.users.find(_id: userId).observe
      added: (user) =>
        Dyad.find({userId: user._id}).observe
          added: (dyad) =>
            @sub.added 'dyads', dyad._id, dyad
            @user dyad.friendId
          removed: (dyad) =>
            @sub.removed 'dyads', dyad._id


Meteor.publish 'user', (id) ->
  (new UsersRelation @).user(id)
  @ready()

Meteor.publish 'friends', (userId) ->
  (new UsersRelation @).friends(userId)
  @ready()