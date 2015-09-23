describe 'components', ->
  describe 'tooltip', ->

    compile = undefined
    scope = undefined
    httpMock = undefined
    tooltip = undefined

    beforeEach module 'app'

    beforeEach inject (_$compile_, _$rootScope_,  _$httpBackend_) ->

      scope = _$rootScope_
      compile = _$compile_
      httpMock = _$httpBackend_

      linkingFunction = _$compile_('<div wh-tool-tip tool-tip-child-selector=".wh-reviewed"><span data-trigger="hover" class="wh-reviewed glyphicon glyphicon-ok" title="Reviewed" data-placement="right"></span></div>')
      scope = _$rootScope_
      tooltip = linkingFunction(scope)
      scope.$apply()

    xit 'should get the trigger hover on the first reviewed column', ->
      angular.element(tooltip).find('.wh-reviewed').trigger('mouseover')
      console.log angular.element(tooltip).find('span.wh-reviewed:first')