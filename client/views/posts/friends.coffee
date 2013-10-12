Template.postsFriends.helpers

  postsCount: ->
    @.count()

  friendsCount: ->
    Dyad.count(userId: User.current().id)