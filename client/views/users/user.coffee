Template.usersUser.helpers
  name: ->
    User.first(@_id).name()