class DynamicSeries extends Controller
  constructor: ($log) ->
    @series = [
      { name: "Excellent Driver", subTitle: "0 - 1 points", color: "#2D9D39", visible: true, lineWidth: 2 }
      { name: "Good Driver", subTitle: "2 - 7 points", color: "#33EA38", visible: true, lineWidth: 2 }
      { name: "Warning Driver", subTitle: "8 - 12 points", color: "#F6E332", visible: true, lineWidth: 2 }
      { name: "Elevated Driver", subTitle: "13 - 29 points", color: "#F28B22", visible: true, lineWidth: 2 }
      { name: "High Risk Driver", subTitle: "30+ points", color: "#B23947", visible: true, lineWidth: 2 }
    ]
    @categories = [ '2011<br/>Q4', '2012<br/>Q1', '2012<br/>Q2', '2012<br/>Q3', '2012<br/>Q4', '2013<br/>Q1', '2013<br/>Q2', '2013<br/>Q3', '2013<br/>Q4', '2014<br/>Q1', '2014<br/>Q2', '2014<br/>Q3', '2014<br/>Q4' ]
    @data = [
      [ 1700, 1750, 1800, 1850, 1900, 2000, 2400, 2450, 2600, 2700, 2900, 3200, 3400 ]
      [ 800, 850, 850, 850, 850, 750, 750, 700, 700, 725, 675, 625, 600 ]
      [ 100, 100, 100, 100, 100, 50, 50, 50, 50, 50, 50, 50, 50 ]
      [ 25, 30, 40, 45, 30, 32, 25, 35, 26, 45, 34, 43, 23 ]
      [ 0, 5, 6, 3, 2, 6, 4, 7, 3, 2, 2, 7, 8 ]
    ]
    @pctData =
      for s in @data
        for ix, i of s
          total = (x[ix] for x in @data).reduce (t,s) -> t + s
          i / total
    console.log @pctData

    @showAll = => s.visible = true for s in @series

    @buildTooltip = (point) =>
      $log.debug point
      return "<b> " + Math.round(point.y*100) + "% " + @series[point.series.index].name + "</b><br/><b>Drivers</b> " + @data[point.series.index][point.index]
