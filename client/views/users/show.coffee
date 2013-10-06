Template.usersShow.helpers
  posts: ->
    Post.findByUserId @_id

  followControlState: ->
    if Dyad.count({userId: User.current()._id, friendId: @_id}) > 0
      "control--state--on"
    else
      "control--state--off"