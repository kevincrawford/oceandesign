class whIndeterminateProgress extends Directive
  constructor: (@$log, $interval) ->
    link = (scope, element, attrs) ->
      speed = parseInt(attrs.speed || 50)
      distance = parseInt(attrs.distance || 5)
      scope.size = parseInt(attrs.size || 10)
      scope.currentValue = 0
      goingUp = true
      i = $interval ->
        if goingUp && scope.currentValue >= (100 - distance)
          goingUp = false
        if !goingUp && scope.currentValue <= 0
          goingUp = true
        scope.currentValue += if goingUp then distance else 0-distance
      , speed
      scope.$on 'destroy', () -> $interval.cancel i
    return {
    link
    replace: true
    restrict: 'A'
    templateUrl: 'components/directives/ngDirectives/indeterminateProgress/whIndeterminateProgress.html'
    scope: {}
    }