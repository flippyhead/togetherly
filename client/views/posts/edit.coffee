Template.postsEdit.events
  submit: (e) ->
    e.preventDefault()

    url = $(e.target).find('[name=url]').val()
    emails = $(e.target).find('[name=emails]').val()
    comment = $(e.target).find('[name=comment]').val()

    Meteor.call 'postsCreate', {url, emails, comment}, (error, id) ->
      return alert(error.reason) if error

    Router.go 'postsIndex'