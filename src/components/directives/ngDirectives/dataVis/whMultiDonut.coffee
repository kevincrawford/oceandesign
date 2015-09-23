class whMultiDonut extends Directive
  constructor: (donutHelperService, $log, dataVisColorPaletteService, $timeout) ->
    link = (scope, element, attrs) ->
      createData = () ->
        if !scope.autoOrder
          return scope.data || []
        data = for i in scope.data || []
          i.slice 0
        data.sort (a,b) -> if a[1] > b[1] then -1 else if a[1] < b[1] then 1 else 0
        toEnd = data.splice 1, 1
        if toEnd.length
          data.push toEnd[0]
        data

      element.addClass("wh-multi-donut")
      options =
        colors: dataVisColorPaletteService.getColors()
        chart:
          plotBackgroundColor: null
          plotBorderWidth: 0
          plotShadow: false
          style: fontFamily: '"ProximaNovaRgRegular", Arial, sans-serif'
          events: redraw: ->
            donutHelperService.setChartTitle chart, scope.text, scope.subText
            $timeout ->
              # need to delay this to avoid issue with redraw being null (http://forum.highcharts.com/highcharts-usage/highchart-s-chart-object-looses-redraw-t27650/)
              donutHelperService.setDataLabelFormat chart
            , 1
        title: text: null
        subtitle: text: null
        tooltip:
          formatter: () -> scope.tooltipFormatter(this) || false
          style: padding: 10
        plotOptions:
          pie:
            dataLabels:
              verticalAlign: "bottom" # doesn't seem to have an effect
              connectorPadding: 0
              enabled: true
              useHTML: true
              format: donutHelperService.getDataLabelFormat { plotWidth: element.width() , plotHeight: element.height() }
          series:
            events:
              click: (e) ->
                obj = { point: e.point, value: e.point.percentage / 100, name: e.point.name }
                scope.onValueClicked obj
        series: [
          id: 'data'
          type: 'pie'
          name: 'donut'
          innerSize: '65%'
          data: createData()
        ]
        credits: false
      chart = element.highcharts options
      chart = element.highcharts()

      #TODO: implement labelClicked (click handler on element doesn't get fired - guessing we need to wire things up with highcharts)

      buttons = null
      updateButtons = () ->
        if(buttons)
          buttons.unbind "click", handleClick
        buttons = element.find(".btn").bind "click", handleClick
      updateButtons()

      handleClick = (e) ->
        point = chart.get("data").data[angular.element(e.target).data("point")]
        scope.onLabelClicked { name: (point || {}).name, point: point }

      # deep watch data
      scope.$watch '[data,autoOrder]', (() ->
        chart.get("data").setData createData()
        updateButtons()
        donutHelperService.setDataLabelFormat chart
      ), true
      scope.$watchCollection '[text, subText]', () -> donutHelperService.setChartTitle chart, scope.text, scope.subText
      scope.$on 'reflow', () -> chart.reflow()

    return {
    link
    restrict: 'A'
    scope:
      data: '='
      text: '=?'
      subText: '=?'
      autoOrder: '=?'
      onLabelClicked: '&'
      onValueClicked: '&'
      tooltipFormatter: '&' # passed the data from http://api.highcharts.com/highcharts#tooltip--formatter
    }