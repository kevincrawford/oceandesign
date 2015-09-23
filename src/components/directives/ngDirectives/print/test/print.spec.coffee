describe 'components', ->
  describe 'print', ->

    scope = undefined

    printHtml ='<div><span wh-print myAttr="xxxx"><div></div></span></div>'

    printElem = undefined

    beforeEach module 'app'

    beforeEach inject (_$compile_, _$rootScope_, _$templateCache_, _$httpBackend_, _$controller_) ->
      scope = _$rootScope_.$new()
      printElem = _$compile_(printHtml)(scope)
      scope.$digest()

    it 'should replace html with print directive tags', () ->
      expect(printElem.find('span.glyphicon-print').length).toBe(1)

    it 'should contain helper functions on scope', () ->
      expect(scope.detectUA).toBeDefined()
      expect(scope.printPreview).toBeDefined()

    it 'should detect UserAgent for firefox  (v33.0.2 - windows)', () ->
      expect(scope.detectUA('Mozilla/5.0 (Windows NT 6.1; WOW64; rv:33.0) Gecko/20100101 Firefox/33.0', 'Netscape', '5.0 (Windows)')).toBe('Firefox 33')

    xit 'should detect UserAgent for chrome  (ver? - os?)', () ->
      expect(scope.detectUA('Mozilla/5.0 (Windows NT 6.1; WOW64; rv:33.0) Gecko/20100101 Firefox/33.0', 'Netscape', '5.0 (Windows)')).toBe('Firefox 33')

    xit 'should detect UserAgent for IE  (ver? - os?)', () ->
      expect(scope.detectUA('Mozilla/5.0 (Windows NT 6.1; WOW64; rv:33.0) Gecko/20100101 Firefox/33.0', 'Netscape', '5.0 (Windows)')).toBe('Firefox 33')

    xit 'should detect UserAgent for IE  (ver? - os?)', () ->
      expect(scope.detectUA('Mozilla/5.0 (Windows NT 6.1; WOW64; rv:33.0) Gecko/20100101 Firefox/33.0', 'Netscape', '5.0 (Windows)')).toBe('Firefox 33')

    xit 'should detect UserAgent for IE  (ver? - os?)', () ->
      expect(scope.detectUA('Mozilla/5.0 (Windows NT 6.1; WOW64; rv:33.0) Gecko/20100101 Firefox/33.0', 'Netscape', '5.0 (Windows)')).toBe('Firefox 33')

    xit 'should detect UserAgent for IE  (ver? - os?)', () ->
      expect(scope.detectUA('Mozilla/5.0 (Windows NT 6.1; WOW64; rv:33.0) Gecko/20100101 Firefox/33.0', 'Netscape', '5.0 (Windows)')).toBe('Firefox 33')

