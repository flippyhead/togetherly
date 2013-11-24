Router.map ->

  @route 'infoBookmarklet',
    path: '/info/bookmarklet'

  @route 'infoJoin',
    path: '/info/join'

  @route 'infoHelp',
    path: '/info/help'
    data: ->
      User.current()

  @route 'infoStart',
    path: '/start'