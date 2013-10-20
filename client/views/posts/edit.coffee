Template.postsEdit.events
  submit: (e) ->
    e.preventDefault()

    url = $(e.target).find('[name=url]').val()
    emails = $(e.target).find('[name=emails]').val()
    comment = $(e.target).find('[name=comment]').val()
    source = $(e.target).find('[name=source]').val()

    Meteor.call 'postsCreate', {url, emails, comment, source}, (error, id) ->
      return alert(error.reason) if error

      if source is 'b'
        window.close()
      else
        Router.go 'postsIndex'