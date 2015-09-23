class whPane extends Directive
  constructor: ($log) ->

    link = (scope, element, attrs, tabsController) ->
      scope.tabTitle = attrs.tabTitle
      tabsController.addPane(scope)

    return {
    link
    replace: true
    restrict: 'A'
    transclude: true
    require: "^wh-tabs"
    scope: {
      title: "@"
    }
    templateUrl: 'components/directives/ngDirectives/tab/whPane/whPane.html'
    }