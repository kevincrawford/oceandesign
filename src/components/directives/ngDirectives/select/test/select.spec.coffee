describe 'components', ->
  describe 'multi-select', ->

    scope = undefined

    multiSelectHtml ='<div><div wh-select multiple dropdown options="[ { id:1, ItemDesc: \'Car\' }, { ItemCd: 2, ItemDesc: \'Driver or some long thing to wrap\' }, { ItemCd: 3, ItemDesc: \'Building\' } ]" selected="[]"></div></div>'

    multiSelectElem = undefined

    beforeEach module 'app'

    beforeEach inject (_$compile_, _$rootScope_, _$templateCache_, _$httpBackend_, _$controller_) ->
      scope = _$rootScope_.$new()
      multiSelectElem = _$compile_(multiSelectHtml)(scope)
      scope.$digest()

    it 'should repalce html with multi-select w/ dropdown directive tags', () ->
      expect(multiSelectElem.find('div.wh-multi-select').length).toBe(1)

    xit 'should repalce html with multi-select w/o dropdown directive tags', () ->

    xit 'should repalce html with single-select w/ dropdown directive tags', () ->

    xit 'should repalce html with single-select w/o dropdown directive tags', () ->
