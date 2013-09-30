Router.configure
  layout: 'layout'
  notFoundTemplate: 'errors404'
  loadingTemplate: 'loading'
  before: ->
    return if Meteor.user() or
      _.include(['home', 'postsNew'], @context.route.name)
    if Meteor.loggingIn()
      @render 'loading'
    else
      @render 'accessDenied'
      @stop()


Router.map ->

  @route 'home', path: '/'

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
      Meteor.subscribe 'posts', @params._id
    data: ->
      Post.find @params._id

  @route 'postsLike',
    path: '/posts/:_id/like'
    controller: 'PostsController'
    action: 'subscribe'


  # @route 'postsShare',
  #   path: '/posts/:_id/share'
  #   controller: 'PostsController'
  #   action: 'share'
  #   data: ->
  #     Post.find @params._id

  @route 'subscriptionsNew',
    path: '/subscriptions/new'
    controller: 'SubscriptionsController'
    action: 'new'
    # data: ->
    #   Post.find @params._id

  @route 'usersShow',
    path: '/users/:_id'
    waitOn: ->
      Meteor.subscribe 'user', @params._id
    data: ->
      Meteor.users.findOne @params._id

  @route 'postsIndex', path: '/posts'

  @route 'loading', path: '/loading'


class @PostsController extends RouteController
  subscribe: ->
    Router.go 'postsShow', @params
    Meteor.call 'postsSubscribe', @params._id, (error, id) ->
      return alert(error.reason) if error

class @SubscriptionsController extends RouteController
  new: ->
    @render()
