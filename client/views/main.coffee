Meteor.subscribe 'postsAll', 100
Meteor.subscribe 'friendsPosts'

Meteor.login = (resumeToken, callback) ->
  Accounts.callLoginMethod
    methodArguments: [{resume: resumeToken}]
    userCallback: callback
