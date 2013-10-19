Router.map ->

  @route 'infoBookmarklet',
    path: '/info/bookmarklet'

  @route 'infoGetStarted',
    path: '/info/get-started'
    data: ->
      User.current()
