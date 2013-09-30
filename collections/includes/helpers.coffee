@authorize = (user) ->
  throw new Meteor.Error 401, "You need to login to post new stories" if not user