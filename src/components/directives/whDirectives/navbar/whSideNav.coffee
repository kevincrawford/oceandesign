class whSideNav extends Directive
  constructor: ($location, authenticationService, sideNavService, structurePickerService)->
    link = (scope,ele, attrs) =>

      scope.isAuthenticated = authenticationService.isAuthenticated()
      scope.toggleSideNav = () ->
        sideNavService.toggle()
      scope.toggleStructurePicker = -> structurePickerService.toggle()

    return {
    link
    replace: true
    restrict: 'AE'
    templateUrl : 'components/directives/whDirectives/navbar/whSideNav.html'
    }