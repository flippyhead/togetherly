Template.postsItem.helpers

  users: ->
    subscriptions = Subscription.where(postId: @_id)
    ids = _.pluck subscriptions, 'userId'
    Meteor.users.find _id: {$in: ids}