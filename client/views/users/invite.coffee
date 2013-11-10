Template.usersInvite.helpers
  users: ->
    fids = _.pluck Dyad.where(userId: User.current().id), 'friendId'
    User.find _id: {$in: fids}

Template.usersInvite.events
  submit: (e, $t) ->
    e.preventDefault()

    emails = $t.find('[name=emails]').value
    note = $t.find('[name=note]').value

    Meteor.call 'usersInvite', emails, note, (error, id) ->
      return alert(error.reason) if error

    Router.go 'usersFriends'