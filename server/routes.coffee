tb = Observatory.getToolbox()

# fs = Npm.require 'fs'
# Meteor.Router.add '/p.js', 'GET', ->
#   headers = 'Content-type': 'text/javascript'
#   path = "#{Meteor.settings.root_path}/public/bookmarklet.js"
#   Meteor.call 'postsCreate', @request.query

#   return [200, headers, fs.readFileSync(path)]

Meteor.Router.add '/posts', 'POST', ->

  senderEmail = @request.body['sender']
  recipientEmail = @request.body['recipient']
  body = @request.body['body-plain']

  try
    sender =
      Meteor.users.findOne('emails.address': senderEmail) or
      Accounts.createUser(email: senderEmail)

    Meteor.users.update({_id: sender._id, 'emails.address': senderEmail},
      $set: {'emails.$.verified': true})

    Posts.extractFromText body, sender
  catch e
    tb.error 'Cannot create user: '
    tb.error e

  return 200