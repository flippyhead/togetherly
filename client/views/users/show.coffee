Template.usersShow.helpers
  name: ->
    User.first(@_id).name()

  posts: ->
    Post.findByUserId @_id

  followControlMessage: ->
    if Dyad.count({userId: User.current()._id, friendId: @_id}) > 0
      "Stop Following"
    else
      "Follow"

  followControlState: ->
    if Dyad.count({userId: User.current()._id, friendId: @_id}) > 0
      "control--state--on"
    else
      "control--state--off"