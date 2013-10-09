Template.home.helpers
  posts: ->
    fids = _.pluck Dyad.where(userId: User.current().id), 'friendId'
    pids = _.pluck Subscription.where(userId: {$in: fids}), 'postId'
    Post.find {_id: {$in: pids}}, sort: {createdAt: -1}