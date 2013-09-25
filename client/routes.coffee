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
    data: ->
      Post.find @params._id

  @route 'usersShow',
    path: '/users/:_id'
    waitOn: ->
      Meteor.subscribe 'user', @params._id
    data: ->
      Meteor.users.findOne @params._id

  @route 'postsIndex', path: '/posts'

  @route 'loading', path: '/loading'