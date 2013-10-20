Template.postsFriends.helpers

  postsCount: ->
    @.count()

  hasPosts: ->
    @.count() > 0

  friendsCount: ->
    Dyad.count(userId: User.current().id)