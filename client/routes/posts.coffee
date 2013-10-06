Router.map ->

  @route 'postsNew',
    template: 'postsEdit'
    path: '/posts/new'

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
      Meteor.subscribe 'posts', @params._id
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

  @route 'postsIndex', path: '/posts'

  @route 'loading', path: '/loading'

class @PostsController extends RouteController
  subscribe: ->
    Router.go 'postsShow', @params
    Meteor.call 'postsSubscribe', @params._id, (error, id) ->
      return alert(error.reason) if error

  authThenShow: ->
    Meteor.login @params.resumeToken, =>
      Router.go 'postsShow', @params
