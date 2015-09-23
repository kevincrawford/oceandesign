class whToolTip extends Directive
  constructor: () ->
    link = (scope, ele, attrs) ->
      angular.element(ele).tooltip {
        container: "body"
        selector: attrs.toolTipChildSelector
      }
    return{
      link
      restrict: 'A'
      scope:{}
    }


