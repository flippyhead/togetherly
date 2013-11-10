Meteor.login = (resumeToken, callback) ->
  Accounts.callLoginMethod
    methodArguments: [{resume: resumeToken}]
    userCallback: callback