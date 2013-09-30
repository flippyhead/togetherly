class @Comment extends Minimongoid

  @_collection: new Meteor.Collection 'comments'

Meteor.methods
  commentsCreate: (attrs) ->
    user = Meteor.user()
    userId = user._id
    {postId, comment} = attrs

    throw new Meteor.Error 401, "You need to login to comment" if not user

    comment = Comment.create {userId, postId, comment}
    throw new Meteor.Error 422, comment.error_message() unless comment.isValid()

    Post._collection.update postId, $inc: {commentsCount: 1}

    comment