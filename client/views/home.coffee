Template.home.helpers
  posts: ->
    posts = []
    Dyad.find({userId: User.current().id}).forEach (dyad)->
      Subscription.find({userId: dyad.friendId}).forEach (subscription) ->
        posts.push Post.find subscription.postId
    posts