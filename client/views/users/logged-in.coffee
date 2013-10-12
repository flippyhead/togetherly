Template.usersLoggedIn.helpers
  gravatarImageUrl: ->
    User.current().profile.gravatarImageUrl

Template.usersLoggedIn.events
  'click [data-ref=logout]': (e)->
      e.preventDefault()

      Meteor.logout (error) ->
        return alert(error.reason) if error