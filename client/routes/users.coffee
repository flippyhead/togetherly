Router.map ->

  @route 'usersInvite',
    path: '/user/invite'

  @route 'usersWelcome',
    path: '/user/welcome'
    data: ->
      User.current()

  @route 'usersFriends',
    path: '/user/friends'
    waitOn: ->
      Meteor.subscribe 'user', User.current().id
    data: ->
      fids = _.pluck Dyad.where(userId: User.current().id), 'friendId'
      User.find _id: {$in: fids}

  @route 'usersNew',
    path: '/users/new'

  @route 'usersShow',
    path: '/users/:_id'
    waitOn: ->
      Meteor.subscribe 'user', @params._id
    data: ->
      Meteor.users.findOne @params._id

  @route 'usersFollow',
    path: '/users/:_id/follow'
    controller: 'UsersController'
    action: 'follow'

  @route 'usersAuth',
    path: '/i/:resumeToken'
    controller: 'UsersController'
    action: 'auth'


class @UsersController extends RouteController

  auth: ->
    Meteor.login @params.resumeToken, =>
      Router.go 'postsShow', @params

  follow: ->
    Router.go 'usersShow', @params
    Meteor.call 'usersFollow', @params._id, (error, id) ->
      return alert(error.reason) if error
