Template.postsEdit.events
  submit: (e) ->
    e.preventDefault()

    url = $(e.target).find('[name=url]').val()

    Meteor.call 'postsCreate', {url}, (error, id) ->
      return alert(error.reason) if error
      Router.go 'postsIndex'