class whExpand extends Directive
  constructor: (@$log) ->
    link = (scope, element, attrs) ->
      element.addClass "wh-expand"
      if attrs.autoExpand
        scope.expanded = true
    return {
    link
    templateUrl: "components/directives/ngDirectives/expand/whExpand.html"
    restrict: 'A'
    controller: 'whExpandController'
    transclude: true
    scope:
      text: '=?'
      html: '=?'
      expanded: '=?'
    }