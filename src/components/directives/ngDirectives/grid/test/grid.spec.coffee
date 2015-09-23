describe 'components', ->
  describe 'whGrid', ->

    compile = undefined
    scope = undefined
    httpMock = undefined
    slickGrid = undefined

    beforeEach module 'app'

    beforeEach inject ($rootScope,_$compile_,_$httpBackend_, _$q_) ->

      scope = $rootScope.$new()
      compile = _$compile_
      httpMock = _$httpBackend_

      # populate scope with grid configuration
      gridData = JSON.parse '{"testData":[{"test1" : "test1", "test2" :"test2_data_1", "test3" : "test3_data_1", "test4" : "test4_data_1"},{"test1" : "test2_data_2", "test2" :"test2_data_2", "test3" : "test3_data_2", "test4" : "test4_data_2"}]}'

      # build a promise so that it can be passed in as a parameter to the slick grid's data source function
      getGridData = () ->
        result = _$q_.defer()
        result.resolve {
          results: gridData['testData']
        }
        result.promise
      # populate grid configuration object

      gridTemplate = '<div wh-grid configuration="gridConfiguration" on-displayed="onDisplayed(displayed)" auto-display-first-item="true" style="min-height: 500px" multiselect="true" on-selected="onSelected(selected)"></div>'
      linkingFunction = compile gridTemplate
      slickGrid = linkingFunction scope
      scope.gridConfiguration =
        columns : [
          {index : 'test1', title : 'test1'}
          {index : 'test2', title : 'test2'}
          {index : 'test3', title : 'test3'}
          {index : 'test4', title : 'test4'}
        ]
        initialSort: 'test1'
        dataSource: getGridData()
      scope.$digest()
      slickGrid = angular.element slickGrid

    it 'should intitalize slick grid and generate grid html', ->
      expect(slickGrid.find('.slick-header').length).not.toBe(0)

    xit 'should build slick canvas with all the data passed in to the datasource', ->
      expect(slickGrid.find('.grid-canvas > .ui-widget-content').length).toEqual(4)
