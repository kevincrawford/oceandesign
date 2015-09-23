class whAutoPane extends Directive
  constructor: ($log) ->

    link = (scope, element, attrs, tabsController) ->
      scope.tabTitle = attrs.tabTitle
      tabsController.addPane(scope)
      scope.selectThis = -> tabsController.select scope

    return {
    link
    replace: true
    restrict: 'A'
    transclude: true
    require: "^wh-auto-tabs"
    scope: {
      title: "@"
    }
    templateUrl: 'components/directives/ngDirectives/tab/whAutoPane/whAutoPane.html'
    }