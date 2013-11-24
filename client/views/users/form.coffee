Template.usersForm.events
  submit: (e, $t) ->
    e.preventDefault()

    email = $t.find('[name=email]').value
    firstName = $t.find('[name=firstName]').value
    lastName = $t.find('[name=lastName]').value
    password = $t.find('[name=password]').value
    options = {email, password, profile: {firstName, lastName}}

    Accounts.createUser options, (error) ->
      alert(error) if error
      Router.go 'usersInvite'