class SimpleMap extends Controller
  createData: (count) ->
    @data = for l in [1..5]
      for x in [1..(count/5)]
        { lat: Math.random() * 20 + 30, lng: Math.random() * 45 - 120, driverName: Math.random() }
  constructor: (@$log, $scope) ->
    @createData(100)

    @series = [
      { name: "Excellent Driver", subTitle: "0 - 1 points", color: "#2D9D39"}
      { name: "Good Driver", subTitle: "2 - 7 points", color: "#33EA38" }
      { name: "Warning Driver", subTitle: "8 - 12 points", color: "#F6E332" }
      { name: "Elevated Driver", subTitle: "13 - 29 points", color: "#F28B22" }
      { name: "High Risk Driver", subTitle: "30+ points", color: "#B23947" }
    ]
  buildTooltip: (point) =>
    seriesIx = point.series.index
    seriesItem = @series[seriesIx]
    dataItem = @data[seriesIx][point.index]
    "<b>" + seriesItem.name + "</b><br/>" + dataItem.driverName
  buildGroupTooltip: (point, group) =>
    seriesIx = point.series.index
    seriesItem = @series[seriesIx]
    v = "<b>" + group.pointsIx.length + " " + seriesItem.name  + (if group.pointsIx.length > 1 then "s" else "") + "</b>"
    for ix in group.pointsIx
      dataItem = @data[seriesIx][ix]
      v += "<br/>" + dataItem.driverName
    v

