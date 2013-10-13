Template.sessionsNew.events
  'click [data-ref=loginWithFacebook]': (e, $t) ->
    e.preventDefault()

    Meteor.loginWithFacebook {}, (error) ->
      return alert(error.reason) if error

  submit: (e, $t) ->
    e.preventDefault()

    email = $t.find('[name=email]').value
    password = $t.find('[name=password]').value

    Meteor.loginWithPassword email, password, (error) ->
      return alert(error.reason) if error