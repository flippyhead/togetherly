Accounts.loginServiceConfiguration.remove
  service: "facebook"

Accounts.loginServiceConfiguration.insert
  service: "facebook"
  appId: "203431956505228"
  secret: "eb284da4693a497c4090d9fcbe58ea30"

Meteor.startup ->
  Meteor.settings.env ?= 'development'

  if Meteor.settings.env is 'production'
    process.env.MAIL_URL = Meteor.settings.MAIL_URL