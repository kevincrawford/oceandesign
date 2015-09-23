class MultiDonut extends Controller
  constructor: ($log) ->
    @autoOrder = true
    @data = [
      ['Thing', 234]
      ['Other thing', 203]
      ['Another', 32]
    ]
    @tooltips = [ 'One', 'Two', 'Three']
    @text = "12"
    @subText = "description"
    @labelClicked = (arg) ->
      window.alert arg
    @valueClicked = (name, value) ->
      window.alert "name: " + name + ", value: " + value
    @buildTooltip = (point) =>
      $log.debug point
      @tooltips[point.x]