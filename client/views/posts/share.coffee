Template.postsShare.events
  submit: (e, $t) ->
    e.preventDefault()

    postId = @id
    emails = $t.find('[name=emails]').value
    comment = $t.find('[name=comment]').value

    Meteor.call 'postsCreate', {postId, emails, comment}, (error, id) ->
      return alert(error.reason) if error

    Router.go 'postsShow', _id: postId