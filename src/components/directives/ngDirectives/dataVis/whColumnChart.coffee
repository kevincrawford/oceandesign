class whColumnChart extends Directive
  constructor: (whSeriesChartService) ->
    return whSeriesChartService.createInstance { chartType: 'column', class: 'wh-column-chart' }
