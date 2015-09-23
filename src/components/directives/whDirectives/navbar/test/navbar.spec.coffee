describe 'components', ->
  describe 'navbar', ->

    compile = undefined
    scope = undefined
    templateCache = undefined
    httpMock = undefined
    topNavMenu = undefined

    beforeEach module 'app'

    beforeEach inject (_$compile_, _$rootScope_, _$templateCache_, _$httpBackend_) ->
      templateCache = _$templateCache_
      scope = _$rootScope_
      compile = _$compile_
      httpMock = _$httpBackend_

      topNavHtml =  templateCache.get 'components/directives/whDirectives/navbar/whTopNav.html'
      httpMock.expectGET('components/directives/whDirectives/navbar/whTopNav.html').respond(200,topNavHtml )
      linkingFunction = _$compile_('<div wh-top-nav></div>')
      scope = _$rootScope_
      topNavMenu = linkingFunction(scope)
      scope.$apply()

    it 'should get the template Html and inject into directive html', ->
      expect(angular.element(topNavMenu).find(".top-header").length).not.toEqual(0)

    xit 'should show main menu on hover', ->
      # unable to trigger 'hover' event at present because using temporary implementation
      # TODO: implement this test once final (psd2html) implementation of nav is in place
      expect(angular.element(topNavMenu).find(".fleet-topics").trigger('hover').css('display')).toEqual('inline-block')

    xit 'should hide main menu on mouseout', ->
      # unable to trigger 'mouseout' event at present because using temporary implementation
      # TODO: implement this test once final (psd2html) implementation of nav is in place
      expect(angular.element(topNavMenu).find(".fleet-topics").trigger('mouseout')).not.toEqual(0)