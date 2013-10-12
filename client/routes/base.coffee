Router.configure
  layout: 'layout'
  notFoundTemplate: 'errors404'
  loadingTemplate: 'loading'
  before: ->
    return if Meteor.user() or
      _.include(['home', 'postsIndex', 'postsShowWithAuth'], @context.route.name)
    if Meteor.loggingIn()
      @render 'loading'
    else
      @render 'accessDenied'
      @stop()

Router.map ->

  @route 'home',
    path: '/'
    controller: 'HomeController'
    action: 'home'
    data: ->
      return {} unless userId = User.current()?.id
      fids = _.pluck Dyad.where({userId}), 'friendId'
      pids = _.pluck Subscription.where(userId: {$in: fids}), 'postId'
      Post.find {_id: {$in: pids}}, sort: {createdAt: -1}

class @HomeController extends RouteController
  home: ->
    @render if User.current() then 'home' else 'welcome'
