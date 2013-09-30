Template.postsShow.helpers
  comments: ->
    Comment.find postId: @id

  subscriptionIcon: ->
    if Subscription.count({userId: Meteor.userId(), postId: @id}) > 0
      'glyphicon-star'
    else
      'glyphicon-star-empty'

  users: ->
    subscriptions = Subscription.where(postId: @_id)
    ids = _.pluck subscriptions, 'userId'
    Meteor.users.find _id: {$in: ids}

Template.postsShow.events
  submit: (e) ->
    e.preventDefault()

    $comment = $(e.target).find('[name=comment]')
    comment = $comment.val()

    Meteor.call 'commentsCreate', {comment, postId: @id}, (error, id) ->
      return alert(error.reason) if error
      $comment.val ''