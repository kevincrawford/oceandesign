class Device extends Service
  constructor: (@$rootScope, $window) ->
    supportsMediaQueries = if $window.matchMedia? then $window.matchMedia("only all").matches else false

    update = =>
      @$rootScope.currentDevice = getCurrent()
    @$rootScope.$watch 'currentDevice', =>
      @$rootScope.$broadcast 'CurrentDeviceChanged'

    if supportsMediaQueries
      deviceClasses =
        xs: "(max-width: 767px)"
        sm: "(min-width: 768px) and (max-width: 991px)"
        md: "(min-width: 992px) and (max-width: 1199px)"
        ld: "(min-width: 1200px)"
      getCurrent = ->
        for k,v of deviceClasses when $window.matchMedia(v).matches
          return k
        return null
      for k,v of deviceClasses
        $window.matchMedia(v).addListener => @$rootScope.$apply update
    else
      deviceClasses =
        xs: 0
        sm: 768
        md: 992
        ld: 1200
      getCurrent = ->
        w = $window.document.body.clientWidth
        last = k for k,v of deviceClasses when v <= w
        return last
      $($window).on "resize", => @$rootScope.$apply update

    @current = => @$rootScope.currentDevice || getCurrent()