class SideNav extends Service
  # Provides open/close/toggle methods to affect the side nav expand/collapse
  constructor: ($timeout,$rootScope,authenticationService) ->
    body = $("body")
    hasAutoClosed = false
    autoClose = null
    reflowAfterAnimationComplete = ->
      body.one "webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend webkitAnimationEnd oanimationend msAnimationEnd animationend", ->
        $rootScope.$apply -> $rootScope.$broadcast "reflow"
    doAutoClose = () ->
      if !hasAutoClosed && !autoClose
        autoClose = $timeout () ->
          autoClose = null
          hasAutoClosed = true
          if !body.hasClass("sidenav-minified")
            body.addClass("sidenav-minified")
            reflowAfterAnimationComplete()
        , 2000
    if authenticationService.isAuthenticated()
      # we're authenticated already, so prep the auto-close
      doAutoClose()
    else
      # after authentication, if we haven't already, auto-close the side bar
      $rootScope.$on 'isAuthenticated', () ->
        if authenticationService.isAuthenticated()
          doAutoClose()
    cancelAutoClose = () ->
      if autoClose
        $timeout.cancel autoClose
        autoClose = null
    @isOpen = () ->
      return !body.hasClass("sidenav-minified")
    @open = () ->
      cancelAutoClose()
      body.removeClass("sidenav-minified")
      reflowAfterAnimationComplete()
      null
    @close = () ->
      cancelAutoClose()
      body.addClass("sidenav-minified")
      reflowAfterAnimationComplete()
      null
    @toggle = () =>
      if @isOpen()
        @close()
      else
        @open()
