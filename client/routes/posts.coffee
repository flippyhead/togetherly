Router.map ->

  @route 'home',
    path: '/'
    after: ->
      if User.current()
        Router.go 'postsMy'
      else
        Router.go 'infoStart'

  @route 'postsMy',
    path: '/posts/my'
    waitOn: ->
      Meteor.subscribe 'friendsPosts', 99
    data: ->
      Post.find {}, sort: {createdAt: -1}

  @route 'postsIndex',
    path: '/posts'
    waitOn: ->
      Meteor.subscribe 'postsAll', 100
    data: ->
      Post.find {}, sort: {createdAt: -1}

  @route 'postsSubmit',
    template: 'postsEdit'
    path: '/posts/new/:url'
    layoutTemplate: 'blank'
    waitOn: ->
      Meteor.subscribe 'friends', User.current().id
    data: ->
      new Post(url: @params.url, source: Post.sourceBookmarklet)

  @route 'postsNew',
    template: 'postsEdit'
    path: '/posts/new'
    waitOn: ->
      Meteor.subscribe 'friends', User.current().id
    data: ->
      new Post(source: Post.sourceWeb)

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
      [Meteor.subscribe('post', @params._id), Meteor.subscribe('user', User.current().id)]
    data: ->
      Post.find @params._id

  @route 'postsShowWithAuth',
    path: '/p/:_id/:resumeToken'
    controller: 'PostsController'
    action: 'authThenShow'

  @route 'loading', path: '/loading'


class @PostsController extends RouteController

  authThenShow: ->
    Meteor.login @params.resumeToken, =>
      Router.go 'postsShow', @params
