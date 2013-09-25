Template.postsShow.helpers
  comments: ->
    Comment.find postId: @id

Template.postsShow.events
  submit: (e) ->
    e.preventDefault()

    $body = $(e.target).find('[name=comment]')
    body = $body.val()

    Meteor.call 'commentsCreate', {body, postId: @id}, (error, id) ->
      return alert(error.reason) if error
      $body.val ''