class @Dyad extends Minimongoid

  @_collection: new Meteor.Collection 'dyads'

  validate: ->
    @error 'userId', 'userId is required.' unless @userId
    @error 'friendId', 'friendId is required.' unless @friendId

  error_message: ->
    msg = ''
    for i in @errors
      for key, value of i
        msg += "#{value}"
    msg
