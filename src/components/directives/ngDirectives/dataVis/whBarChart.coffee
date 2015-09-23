class whBarChart extends Directive
  constructor: (whSeriesChartService) ->
    return whSeriesChartService.createInstance { chartType: 'bar', class: 'wh-bar-chart' }
