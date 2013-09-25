Template.commentsItem.helpers
  user: ->
    Meteor.users.findOne @userId