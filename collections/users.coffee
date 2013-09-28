if Meteor.isServer
  Accounts.onCreateUser (options, user) ->

    if options.profile?
      user.profile = options.profile

    if facebook = user.services?.facebook
      (user.emails ?= []).push {address: facebook.email, verified: yes}

    if email = user.emails?[0]
      email.verified = true
      user.gravatarImageUrl = Gravatar.imageUrl email.address

    user