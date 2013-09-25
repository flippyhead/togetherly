Template.postsIndex.helpers
  posts: ->
    Post.find {},
      sort: {createdAt: -1}