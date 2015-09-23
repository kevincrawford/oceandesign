class whTopNav extends Directive
  constructor: ($location, authenticationService, routesService, $rootScope, $window)->
    link = (scope,ele, attrs) =>
      scope.isAuthenticated = authenticationService.isAuthenticated()
      setItems = () ->
        p = $location.path()
        scope.items =
          for item in routesService.getChildren("/")
            {
              label: item.label
              href: item.href
              active: p.substring(0,item.href.length) == item.href
            }
      setItems()
      $rootScope.$on "$locationChangeSuccess", setItems

      # need to re-trigger this after loading our content, as it's normally initialized before our content is
      $window.picturefill()
    return {
    link
    replace: true
    restrict: 'AE'
    templateUrl : 'components/directives/whDirectives/navbar/whTopNav.html'
    }
