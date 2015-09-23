class DynamicStacked extends Controller
  constructor: (@$log, $scope) ->
    @selectedColors = ["#B23947", "#F28B22", "#F6E332", "#33EA38", "#2D9D39"]
    @deselectedColors = ["#AFAFAF", "#EDEDED", "#F4F4F4", "#E8E8E8", "#9B9B9B"]
    @series = [
      { name: "High Risk Driver", subTitle: "30+ points", color: @deselectedColors[0], stacking: "normal" }
      { name: "Elevated Driver", subTitle: "13 - 29 points", color: @deselectedColors[1], stacking: "normal" }
      { name: "Warning Driver", subTitle: "8 - 12 points", color: @deselectedColors[2], stacking: "normal" }
      { name: "Good Driver", subTitle: "2 - 7 points", color: @deselectedColors[3], stacking: "normal" }
      { name: "Excellent Driver", subTitle: "0 - 1 points", color: @deselectedColors[4], stacking: "normal" }
    ]
    @showCategoryLabels = false
    @showValueAxisLabels = true
    @selected = 4
    $scope.$watch 'c.selected', =>
      for ix, i of @series
        i.color = if (""+ix) == (""+@selected) then @selectedColors[ix] else @deselectedColors[ix]
    @categories = [ '' ]
    @data = [
      [ 20 ]
      [ 50 ]
      [ 100 ]
      [ 800 ]
      [ 1700 ]
    ]
