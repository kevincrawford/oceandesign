describe 'components', ->
  describe 'data visualizations', ->

    scope = undefined

    columnChartHtml ='<div wh-column-chart chart-title="\'This is the title\'" categories="[ \'One\', \'Two\', \'Three\', \'Four\' ]" series="[ \'Data\' ]" data="[ [ 15, 10, 4, 30 ] ]"></div>'
    singleDonutHtml ='<div wh-single-donut class="wh-single-donut-small" text="\'1,001\'" value="1"></div>'
    lineChartHtml = '<div wh-line-chart chart-title="\'This is the title\'" categories="[ \'One\', \'Two\', \'Three\', \'Four\' ]" series="[ \'Data\' ]" data="[ [ 15, 10, 4, 30 ] ]"></div>'
    multiDonutHtml = '<div wh-multi-donut="" text="\'other\'" data="[ [ \'One\', 123 ], [\'Two\', 234], [\'Three\', 434], [\'Four\', 143 ] ]" auto-order="true"></div>'

    columnChartElem = undefined
    singleDonutElem = undefined
    lineChartElem = undefined
    multiDonutElem = undefined

    beforeEach module 'app'

    beforeEach inject (_$compile_, _$rootScope_, _$templateCache_, _$httpBackend_, _$controller_) ->
      scope = _$rootScope_.$new()
      columnChartElem = _$compile_(columnChartHtml)(scope)
      singleDonutElem = _$compile_(singleDonutHtml)(scope)
      lineChartElem = _$compile_(lineChartHtml)(scope)
      multiDonutElem = _$compile_(multiDonutHtml)(scope)
      scope.$digest()

    it 'should create column chart using high charts', () ->
      expect(columnChartElem.find('div.highcharts-container').length).toBe(1)

    it 'should create single donut using high charts', () ->
      expect(singleDonutElem.find('div.highcharts-container').length).toBe(1)

    it 'should create line chart using high charts', () ->
      expect(lineChartElem.find('div.highcharts-container').length).toBe(1)

    it 'should create multi donut using high charts', () ->
      expect(multiDonutElem.find('div.highcharts-container').length).toBe(1)

