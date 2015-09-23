class whTabs extends Directive
  constructor: ($log) ->

    link = (scope, element, attrs ) ->

      if (attrs.aligntabs == 'left')
        element.addClass('tabs-left')
      if (attrs.aligntabs == 'right')
        element.addClass('tabs-right')
      if (attrs.aligntabs == 'bottom')
        element.addClass('tabs-below')

      scope.autoCollapse = false
      scope.collapsible = false
      if (attrs.autocollapse?)
        scope.autoCollapse = true
        scope.collapsible = true
      if (attrs.collapsible?)
        scope.collapsible = true

      scope.setCollapsible()

    return {
    link
    replace: true
    restrict: 'A'
    transclude: true
    scope: {}
    controller: 'tabsController'
    templateUrl: 'components/directives/ngDirectives/tab/whTabs/whTabs.html'
    }