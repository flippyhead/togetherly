Template.home.helpers

  friendsPostsCount: ->
    @friendsPosts?.count()

  hasFriendsPosts: ->
    @friendsPosts?.count() > 0

  friendsCount: ->
    Dyad.count(userId: User.current().id)
