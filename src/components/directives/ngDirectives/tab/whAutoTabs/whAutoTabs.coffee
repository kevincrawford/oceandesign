class whAutoTabs extends Directive
  constructor: ($log, deviceService) ->

    link = (scope, element, attrs ) ->
      update = ->
        device = deviceService.current()
        element.removeClass('tabs-left').removeClass('tabs-inline')
        switch device
          when "ld" then element.addClass 'tabs-left'
          when "xs" then element.addClass 'tabs-inline'

      scope.$on "CurrentDeviceChanged", update
      update()

      scope.autoCollapse = false
      scope.collapsible = false

    return {
    link
    replace: true
    restrict: 'A'
    transclude: true
    scope: {}
    controller: 'tabsController'
    templateUrl: 'components/directives/ngDirectives/tab/whAutoTabs/whAutoTabs.html'
    }