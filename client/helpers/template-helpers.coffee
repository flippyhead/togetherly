Handlebars.registerHelper 'friendlyCreatedAt', ->
  isToday = moment().subtract('days', 1).isBefore @createdAt
  moment(@createdAt).format if isToday then 'LT' else 'll LT'

Handlebars.registerHelper 'uri', (url) ->
  url.replace /https?:\/\//, ''
