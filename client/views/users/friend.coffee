Template.usersFriend.helpers
  name: ->
    User.first(@_id).name()