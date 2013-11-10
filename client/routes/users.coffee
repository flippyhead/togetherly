Router.map ->

  @route 'usersInvite',
    path: '/user/invite'

  @route 'usersFriends',
    path: '/user/friends'
    waitOn: ->
      Meteor.subscribe 'friends', User.current().id
    data: ->
      User.find {}, sort: {createdAt: -1}

  @route 'usersNew',
    path: '/users/new'

  @route 'usersHome',
    path: '/user'
    before: ->
      Router.go 'usersShow', _id: User.current().id

  @route 'usersShow',
    path: '/users/:_id'
    waitOn: ->
      Meteor.subscribe 'user', @params._id
    data: ->
      Meteor.users.findOne @params._id

  @route 'usersAuth',
    path: '/u/:resumeToken'
    controller: 'UsersController'
    action: 'auth'


class @UsersController extends RouteController

  auth: ->
    Meteor.login @params.resumeToken, =>
      Router.go 'home'