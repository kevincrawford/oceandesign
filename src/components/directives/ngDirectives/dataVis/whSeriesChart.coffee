class whSeriesChart extends Service
  constructor: (@$log, @dataVisColorPaletteService) ->
  createInstance: (settings) ->
    link = (scope, element, attrs) =>

      buildData = (ix) ->
        angular.copy((scope.data || [])[ix] || [])
      buildSeries = () ->
        visibleSeries = (i for i in scope.series || [] when !i.visible? || i.visible).length
        if !scope.series? or scope.series.length == 0
          emptyData = [{ data:[] }]
          return emptyData
        for i, ix in scope.series || []
          basePart = { id: 'series' + ix, name: i, data: buildData(ix) }
          if settings.chartType == 'line'
            if visibleSeries == 1
              jQuery.extend basePart, {
                marker: enabled: true
              }
            else if chart
              jQuery.extend basePart, {
                marker: enabled: false
              }
          if typeof i is 'string'
            basePart
          else
            jQuery.extend basePart, i
      buildTitle = () -> if scope.chartTitle then text: scope.chartTitle, x: -20 else null#margin: 25 else null
      buildSubTitle = () -> if scope.chartSubTitle then text: scope.chartSubTitle, x: -20 else null

      element.addClass("wh-series-chart")
      element.addClass(settings.class)

      lineColor = "#C0C0C0"
      paths = []
      drawPlotExtension = (chart, sx, sy, dx, dy) ->
        # at the limits, we seem to get off by one, so....
        sx = chart.plotLeft + chart.plotWidth + 1 if Math.abs(chart.plotLeft + chart.plotWidth - sx) < 4 and dx == 0
        sy = chart.plotTop - 1 if Math.abs(chart.plotTop - sy) < 4 and dy == 0

        # when drawing lines, Highcharts seems to draw on the half-pixel...
        sx = Math.round(sx) - 0.5 if dx == 0
        sy = Math.round(sy) + 0.5 if dy == 0

        paths.push chart.renderer.path(["M", sx, sy, "L", sx + dx, sy + dy]).attr({ stroke: lineColor, 'stroke-width': 1 }).add()

      tickLength = 5
      bullseye = null
      chartSettings =
        colors: @dataVisColorPaletteService.getColors()
        title: buildTitle()
        subtitle: buildSubTitle()
        chart:
          plotBackgroundColor: if scope.plotBackgroundColor? then "#" + scope.plotBackgroundColor else "#ffffff"
          zoomType: 'x'
          type: settings.chartType
          style: 
            fontFamily: '"ProximaNovaRgRegular", Arial, sans-serif'
          spacing: [tickLength, tickLength, tickLength, tickLength]
          events: redraw: (e) ->
            if paths
              p.destroy() for p in paths when p.renderer

            if @options.chart.type == 'bar'
              vAxis = @xAxis[0]
              hAxis = @yAxis[0]
            else
              hAxis = @xAxis[0]
              vAxis = @yAxis[0]

            # h axis extended left/right
            if vAxis.options.tickWidth == 0
              if !scope.displayAsStacked? then drawPlotExtension @, chart.plotLeft, chart.plotTop + chart.plotHeight, -tickLength, 0
            else
              for tp in vAxis.tickPositions
                drawPlotExtension @, chart.plotLeft + chart.plotWidth, vAxis.toPixels(tp, false), tickLength, 0

           
            # v axis extended down/up
            if hAxis.options.tickWidth == 0
              if !scope.displayAsStacked? then drawPlotExtension @, chart.plotLeft, chart.plotTop + chart.plotHeight, 0, tickLength
            else
              for tp in hAxis.tickPositions
                drawPlotExtension @, hAxis.toPixels(tp, false), chart.plotTop, 0, -tickLength

        tickLength:
          formatter: () -> scope.tooltipFormatter(this) || false
          shadow: true
          borderWidth: 0
          backgroundColor: "#f0f0f0"
          positioner: (w, h, p) ->
            ###r = { x: p.plotX + chart.plotLeft - w/2, y: p.plotY + chart.plotTop - h - 20 }
            if r.x < chart.plotLeft - 15
              r.x = chart.plotLeft - 15 # adjust to avoid left edge
            if r.x > chart.plotWidth + chart.plotLeft - w + 10
              r.x = chart.plotWidth + chart.plotLeft - w + 10 # adjust to avoid right edge
            if r.y < chart.plotTop
              r.y = p.plotY + chart.plotTop + 20 # flip to bottom to avoid top edge
            r###
            r = { x: p.plotX + chart.plotLeft - w/2, y: p.plotY + chart.plotTop - h - 15 }
            if r.x < chart.plotLeft
              r.x = chart.plotLeft # adjust to avoid left edge
            if r.x > chart.plotWidth + chart.plotLeft - w
              r.x = chart.plotWidth + chart.plotLeft - w # adjust to avoid right edge
            if r.y < chart.plotTop
              r.y = p.plotY + chart.plotTop + 15 # flip to bottom to avoid top edge
            r
          style:
            padding: 15#13
            fontFamily: "'ProximaNovaRgRegular'"
            fontSize: "14px"
            color: "#696868"
            style: 'padding-bottom': '2px'
        tooltip: 
          enabled: if scope.disableHoverState? then false else true
        plotOptions:
          series: 
            events: click: (e) ->
              scope.onClicked point: e.point
            pointPadding: if scope.displayAsStacked? then 0 else 0.1
            groupPadding: if scope.displayAsStacked? then 0 else 0.1
            states:
              hover:
                brightness: if scope.disableHoverState? then 0 else 0.1
            borderWidth: if scope.displayAsStacked? then 0 else 1
          line:
            marker:
              enabled: false
              symbol: 'circle'
              fillColor: 'white'
              radius: 4
              lineColor: null
              lineWidth: 2
              states: hover:
                enabled: true
                radius: 6
            states: hover: halo: false
            # enable markers on hover unless it's the only visible series (in which case the markers would already be on)
            events:
              mouseOver: (e) ->
                  return if (s for s in chart.series when s.visible).length == 1
                  chart.series[e.target.index].update { marker: enabled: true }
              mouseOut: (e) ->
                return if (s for s in chart.series when s.visible).length == 1
                chart.series[e.target.index].update { marker: enabled: false }
            # draw a bullet marker on hover
            point:
              events:
                mouseOver: (e) ->
                  bullseye.destroy() if bullseye && bullseye.renderer
                  bullseye = chart.renderer.circle(this.plotX + chart.plotLeft, this.plotY + chart.plotTop, 3).attr({
                    fill: this.series.color
                    zIndex: 10
                  }).add()
                mouseOut: (e) ->
                  bullseye.destroy() if bullseye && bullseye.renderer
        xAxis:
          gridLineColor: if scope.displayAsStacked? then 'transparent' else lineColor#lineColor
          tickColor: if scope.displayAsStacked? then 'transparent' else lineColor#lineColor
          lineColor: if scope.displayAsStacked? then 'transparent' else lineColor#lineColor
          gridLineWidth: 0
          tickWidth: 0
          minTickInterval: 1
          tickmarkPlacement: "on"
          startOnTick: true
          minPadding: 0
          maxPadding: 0
          tickLength: tickLength
          labels:
            enabled: if scope.showCategoryLabels? then !!scope.showCategoryLabels else true
            formatter: -> (scope.categories || [])[this.value]
            y: 38
        yAxis:
          gridLineColor: lineColor
          tickColor: lineColor
          lineColor: lineColor
          labels:
            enabled: if scope.showValueAxisLabels? then !!scope.showValueAxisLabels else true
            formatter: if attrs.valueIsPercentage? then () -> Math.round(this.value * 100) + "%" else null
            style: { 'font-family': "'ProximaNovaRgRegular'", 'font-size': '13px' }
            x: -30
            y: 4
          ceiling: if attrs.valueIsPercentage? then 1 else null
          floor: if attrs.valueIsPercentage? then 0 else null
          title: null
          gridLineWidth: 1
          minTickInterval: if attrs.valueIsPercentage? then .01 else null
          tickWidth: 1
          startOnTick: true
          minPadding: 0
          maxPadding: 0.05
          tickLength: tickLength
          lineWidth: if scope.displayAsStacked? then 0 else 1
          max: max: if scope.maxYValue? and scope.maxYValue > 0 then scope.maxYValue else null

        legend: false
        series: buildSeries()
        lang: { noData: 'No Data Available'}
        noData: { style:{ fontWeight: 'bold', fontSize: '15px', color: '#303030' } }
        credits: false

      if settings.chartType == 'line'
        jQuery.extend true, chartSettings, {
          xAxis:
            gridLineWidth: 1
            tickWidth: 1
            labels:
              y: 38
          yAxis:
            gridLineWidth: 0
            tickWidth: 0
            labels:
              x: -15
        }
      if settings.chartType == 'bar'
        jQuery.extend true, chartSettings, {
          xAxis:
            labels:
              y: 3
              x: -31 #-16
          yAxis:
            labels:
              x: null
              y: 25#37 
        }

      @$log.debug chartSettings

      chart = element.highcharts(chartSettings)
      chart = element.highcharts()

      scope.$watch 'series', (() ->
        newSeries = buildSeries()
        if chart.series.length == newSeries.length
          for ix, i of [].concat(chart.series)
            i.update newSeries[ix], false
        else
          for i in [].concat(chart.series)
            i.remove false
          for i in buildSeries()
            chart.addSeries i, false
        chart.redraw()
      ), true

      scope.$watch 'data', (() ->
        for i, ix in chart.series
          i.setData buildData(ix), true
      ), true

      scope.$watch 'categories', (() -> chart.xAxis[0].redraw() ), true
      scope.$watch 'showCategoryLabels', () -> chart.xAxis[0].update { labels: enabled: if scope.showCategoryLabels? then !!scope.showCategoryLabels else true  }
      scope.$watch 'showValueAxisLabels', () -> chart.yAxis[0].update { labels: enabled: if scope.showValueAxisLabels? then !!scope.showValueAxisLabels else true }
      scope.$watch 'categoryAxisTitle', -> chart.xAxis[0].update {
        title: if scope.categoryAxisTitle then {
          text: scope.categoryAxisTitle
          align: 'low'
          margin: if settings.chartType == 'bar' then 15 else 10
          style: { 'font-family': "'ProximaNovaRgRegular'", 'font-size': '12px' }
        } else null }
      scope.$watch 'valueAxisTitle', -> chart.yAxis[0].update {
        title: if scope.valueAxisTitle then {
          text: scope.valueAxisTitle
          align: 'low'
          margin: if settings.chartType == 'bar' then 10 else 15
          style: { 'font-family': "'ProximaNovaRgRegular'", 'font-size': '12px' }
        } else null
      }
      scope.$watch 'categoryAxisTitle', -> chart.xAxis[0].update { title: if scope.categoryAxisTitle then { text: scope.categoryAxisTitle } else null }
      scope.$watch 'valueAxisTitle', -> chart.yAxis[0].update { title: if scope.valueAxisTitle then { text: scope.valueAxisTitle } else null }
      scope.$watch 'maxYValue', -> chart.yAxis[0].update {max: if scope.maxYValue? and scope.maxYValue > 0 then scope.maxYValue else null}

      scope.$watchCollection '[chartTitle, chartSubTitle]', () -> chart.setTitle buildTitle(), buildSubTitle()
      scope.$on 'reflow', () -> chart.reflow()

    return {
    link
    restrict: 'A'
    scope:
      categories: '=?'
      showCategoryLabels: '=?'
      showValueAxisLabels: '=?'
      valueIsPercentage: '@?'
      categoryAxisTitle: '@?'
      valueAxisTitle: '@?'
      displayAsStacked: '@?'
      plotBackgroundColor: '@?'
      disableHoverState: '@?'
      maxYValue: '='
      series: '='
      data: '='
      chartTitle: '=?'
      chartSubTitle: '=?'
      onClicked: '&' # passed 'point' from http://api.highcharts.com/highcharts#Point
      tooltipFormatter: '&' # passed the data from http://api.highcharts.com/highcharts#tooltip--formatter
    }
