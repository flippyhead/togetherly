if Meteor.isServer
  Accounts.onCreateUser (options, user) ->
    user.profile = options.profile if options.profile?
    user.gravatarImageUrl = Gravatar.imageUrl options.email
    user