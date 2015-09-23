class whSingleDonut extends Directive
  constructor: (donutHelperService, $log, dataVisColorPaletteService) ->
    link = (scope, element, attrs) ->
      createData = () ->
        v = Math.max(Math.min(scope.value || 0, 1), 0)
        [
          ['data', v],
          ['remainder', 1-v]
        ]

      element.addClass("wh-single-donut")
      chart = element.highcharts(
        colors: dataVisColorPaletteService.getColors()
        title: text: null
        chart:
          plotBackgroundColor: null
          plotBorderWidth: 0
          plotShadow: false
          events: redraw: () -> donutHelperService.setChartTitle chart, scope.text, scope.subText
          style: fontFamily: '"ProximaNovaRgRegular", Arial, sans-serif'
        tooltip:
          formatter: () -> scope.tooltipFormatter(this) || false
          style: padding: 10
        plotOptions:
          pie:
            dataLabels:
              enabled: false
          series:
            events:
              click: (e) ->
                obj = { point: e.point, value: e.point.percentage / 100 }
                if(e.point.index == 0)
                  scope.valueClicked obj
                else
                  scope.notValueClicked obj
        series: [
          id: 'data'
          type: 'pie'
          name: 'donut'
          innerSize: '75%'
          data: createData()
        ]
        credits: false
      )
      chart = element.highcharts()

      scope.$watch 'value', () -> chart.get("data").setData createData()
      scope.$watchCollection '[text, subText]', () -> donutHelperService.setChartTitle chart, scope.text, scope.subText
      scope.$on 'reflow', () -> chart.reflow()

    return {
    link
    restrict: 'A'
    scope:
      value: '='
      text: '=?'
      subText: '=?'
      valueClicked: '&'
      notValueClicked: '&'
      tooltipFormatter: '&' # passed the data from http://api.highcharts.com/highcharts#tooltip--formatter
    }