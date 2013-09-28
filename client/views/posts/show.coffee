Template.postsShow.helpers
  comments: ->
    Comment.find postId: @id

  subscriptionIcon: ->
    if Subscription.count({userId: Meteor.userId(), postId: @id}) > 0
      'glyphicon-heart'
    else
      'glyphicon-heart-empty'

Template.postsShow.events
  submit: (e) ->
    e.preventDefault()

    $body = $(e.target).find('[name=comment]')
    body = $body.val()

    Meteor.call 'commentsCreate', {body, postId: @id}, (error, id) ->
      return alert(error.reason) if error
      $body.val ''