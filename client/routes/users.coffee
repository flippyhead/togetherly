Router.map ->

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

  @route 'loading', path: '/loading'

class @UsersController extends RouteController
  follow: ->
    Router.go 'usersShow', @params
    Meteor.call 'usersFollow', @params._id, (error, id) ->
      return alert(error.reason) if error