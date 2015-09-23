class Donut extends Controller
  constructor: ($window, $log) ->
    @valueClicked = () -> $window.alert("the value")
    @notValueClicked = () -> $window.alert("not the value")
    @tooltipFormatter = (point) ->
      $log.debug point
      (if point.x == 0 then "<b>Selected</b>: " else "<b>Not selected</b>: ") + (point.y*100) + "%"