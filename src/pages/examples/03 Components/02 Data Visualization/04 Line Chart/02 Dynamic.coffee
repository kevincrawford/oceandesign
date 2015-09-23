class LineChart extends Controller
  constructor: ($log) ->
    @series = [ 'Data 1' ]
    @categories = [ 'One', 'Two', 'Three' ]
    @data = [ [ 1, 2, 3 ] ]
    @tooltips = [ [ 'Some', 'Other', 'Value' ]]
    @title = "inner title"
    @subTitle = "sub title"
    @labelClicked = (arg) ->
      window.alert arg
    @valueClicked = (name, value) ->
      window.alert "name: " + name + ", value: " + value

    @buildTooltip = (point) ->
      $log.debug point
      return @tooltips[point.series.index][point.x]

    @addSeries = (name) =>
      @series.push name
      @data.push([1..@categories.length])
      @tooltips.push([1..@categories.length])
    @addCategory = (name) =>
      @categories.push name
      for i in @data
        i.push 0
      for i in @tooltip
        i.push 'New value'

    @clicked = (point) -> window.alert(point.x + ' - ' + point.y)