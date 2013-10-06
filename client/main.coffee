Meteor.subscribe 'postsAll', 100
Meteor.subscribe 'comments'
Meteor.subscribe 'subscriptions'
Meteor.subscribe 'dyads'

Meteor.login = (resumeToken, callback) ->
  Accounts.callLoginMethod
    methodArguments: [{resume: resumeToken}]
    userCallback: callback
