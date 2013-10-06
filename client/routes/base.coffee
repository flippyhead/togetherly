Router.configure
  layout: 'layout'
  notFoundTemplate: 'errors404'
  loadingTemplate: 'loading'
  before: ->
    return if Meteor.user() or
      _.include(['home', 'postsShowWithAuth'], @context.route.name)
    if Meteor.loggingIn()
      @render 'loading'
    else
      @render 'accessDenied'
      @stop()

Router.map ->

  @route 'home',
    path: '/'
    waitOn: ->
      Meteor.subscribe 'friendsPosts'