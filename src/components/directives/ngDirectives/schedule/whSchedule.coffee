class WhSchedule extends Directive
  constructor: (@timeValuesService) ->
    link = (scope, ele, attrs) ->
      scope.timeValues = @timeValuesService.getTimeValues()
      scope.daysOfWeek = @timeValuesService.getDaysOfWeek()
      scope.weeksOfMonth = @timeValuesService.getWeeksOfMonth()
      scope.months = @timeValuesService.getMonths()
    return {
      link
      restrict: 'A'
      templateUrl: 'components/directives/ngDirectives/schedule/whSchedule.html'
      scope:
        value: '=ngModel'
    }
