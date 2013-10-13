Router.configure
  layout: 'layout'
  notFoundTemplate: 'errors404'
  loadingTemplate: 'loading'
  before: ->
    return if Meteor.user() or
      _.include(['home', 'sessionsNew', 'usersNew',
        'postsIndex', 'postsShowWithAuth']
      , @context.route.name)

    if Meteor.loggingIn()
      @render 'loading'
    else
      @render 'accessDenied'
      @stop()

Router.map ->

  @route 'loading', path: '/loading'

  @route 'home',
    path: '/'