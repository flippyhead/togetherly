class @Comment extends Minimongoid

  @_collection: new Meteor.Collection 'comments'

Meteor.methods
  commentsCreate: (attrs) ->
    user = Meteor.user()
    userId = user._id
    {postId, body} = attrs

    throw new Meteor.Error 401, "You need to login to comment" if not user

    comment = Comment.create {userId, postId, body}
    throw new Meteor.Error 422, Comment.error_message() unless comment

    Post._collection.update postId, $inc: {commentsCount: 1}

    comment