describe 'components', ->
  describe 'simple table', ->

    scope = undefined

    simpleTableHtml ='<div><div wh-simple-table source="tableData" columns="[ { index: \'title\', title: \'Title\' }, { index: \'color\', title: \'Color\'}]" selected="selectedData"></div></div>'
    testData = [
      { title: 'foo', value: "something", color: "red" }
      { title: 'bar', value: "another thing", color: "green" }
      { title: 'four', value: "even other things", color: "blue" }
    ]
    simpleTableElem = undefined

    beforeEach module 'app'

    beforeEach inject (_$compile_, _$rootScope_, _$templateCache_, _$httpBackend_, _$controller_, _$q_) ->
      scope = _$rootScope_.$new()
      scope.tableData = _$q_.when(testData)
      scope.selectedData = testData[0]
      simpleTableElem = _$compile_(simpleTableHtml)(scope)
      scope.$digest()

    it 'should repalce html with simple table directive tags', () ->
      expect(simpleTableElem.find('div.table-scroll').length).toBe(1)
