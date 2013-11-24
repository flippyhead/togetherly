Template.postsMy.helpers

  count: ->
    @count()

  friendsCount: ->
    Dyad.count(userId: User.current().id)
