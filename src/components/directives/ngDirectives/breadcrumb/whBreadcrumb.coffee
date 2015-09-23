class whBreadcrumb extends Directive
  constructor: (breadcrumbs, authenticationService) ->
    labelFilter = /^[0-9. ]*/
    link = (scope, element, attrs) ->
      scope.breadcrumbs = breadcrumbs
      scope.isAuthenticated = authenticationService.isAuthenticated()


    return {
      link
      replace: true
      restrict: 'A'
      templateUrl: 'components/directives/ngDirectives/breadcrumb/whBreadcrumb.html'
    }