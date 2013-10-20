Router.map ->

  @route 'home',
    path: '/'
    data: ->
      allPosts = Post.find {}, sort: {createdAt: -1}

      if userId = User.current()?.id
        fids = _.pluck Dyad.where({userId}), 'friendId'
        pids = _.pluck Subscription.where(userId: {$in: fids}), 'postId'
        friendsPosts = Post.find {_id: {$in: pids}}, sort: {createdAt: -1}

      {allPosts, friendsPosts}

  @route 'postsIndex',
    path: '/posts'
    data: ->
      Post.find {}, sort: {createdAt: -1}

  @route 'postsSubmit',
    template: 'postsEdit'
    path: '/posts/new/:url'
    data: ->
      new Post(url: @params.url, source: 'b')

  @route 'postsNew',
    template: 'postsEdit'
    path: '/posts/new'
    data: ->
      new Post(source: 'w')

  @route 'postsEdit',
    path: '/posts/:_id/edit'
    data: ->
      Post.find @params._id

  @route 'postsShow',
    path: '/posts/:_id'
    waitOn: ->
      Meteor.subscribe 'post', @params._id
    data: ->
      Post.find @params._id

  @route 'postsShare',
    path: '/posts/:_id/share'
    waitOn: ->
      Meteor.subscribe 'post', @params._id
    data: ->
      Post.find @params._id

  @route 'postsLike',
    path: '/posts/:_id/like'
    controller: 'PostsController'
    action: 'subscribe'

  @route 'postsShowWithAuth',
    path: '/p/:_id/:resumeToken'
    controller: 'PostsController'
    action: 'authThenShow'

  @route 'loading', path: '/loading'


class @PostsController extends RouteController
  subscribe: ->
    Router.go 'postsShow', @params
    Meteor.call 'postsSubscribe', @params._id, (error, id) ->
      return alert(error.reason) if error

  authThenShow: ->
    Meteor.login @params.resumeToken, =>
      Router.go 'postsShow', @params
