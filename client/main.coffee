Meteor.subscribe 'posts', 100
Meteor.subscribe 'comments'
Meteor.subscribe 'subscriptio2ns'

Meteor.login = (resumeToken, callback) ->
  Accounts.callLoginMethod
    methodArguments: [{resume: resumeToken}]
    userCallback: callback
