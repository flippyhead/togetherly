Template.postsItem.helpers
  title: ->
    @title or @uri

  owner: ->
    Meteor.users.findOne @userId

  users: ->
    subscriptions = Subscription.where(postId: @_id)
    ids = _.pluck subscriptions, 'userId'
    Meteor.users.find _id: {$in: ids}