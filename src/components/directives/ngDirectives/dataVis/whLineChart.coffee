class whLineChart extends Directive
  constructor: (whSeriesChartService) ->
    return whSeriesChartService.createInstance { chartType: 'line', class: 'wh-line-chart' }
