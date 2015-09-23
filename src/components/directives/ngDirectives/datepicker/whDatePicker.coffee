class WhDatePicker extends Directive
  constructor: () ->
    link = (scope, ele, attrs) ->
      opts = {
        maxDate: attrs.maxdate
        minDate: attrs.mindate
      }
      if attrs.id
        datePickerId = '\'#' + attrs.id + '\''
        angular.element(scope.$eval(datePickerId)).datepicker opts
      else
        ele.datepicker opts

    return {
      link
      restrict: 'A'
      scope:{}
    }
