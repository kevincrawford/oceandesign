describe 'components', ->
  describe 'tabs', ->

    testElm ='<div wh-tabs><div wh-pane tab-title="First Tab">First content is</div><div wh-pane tab-title="Second Tab">Second content is</div></div>'
    testElmLeftTabs ='<div wh-tabs alignTabs="left"><div wh-pane title="First Tab">First content is</div><div wh-pane title="Second Tab">Second content is</div></div>'
    testElmRightTabs ='<div wh-tabs alignTabs="right"><div wh-pane title="First Tab">First content is</div><div wh-pane title="Second Tab">Second content is</div></div>'
    testElmBottomTabs ='<div wh-tabs alignTabs="bottom"><div wh-pane title="First Tab">First content is</div><div wh-pane title="Second Tab">Second content is</div></div>'
    testElmCollapsibleTabs ='<div wh-tabs collapsible><div wh-pane title="First Tab">First content is</div><div wh-pane title="Second Tab">Second content is</div></div>'
    testElmAutoCollapsedTabs ='<div wh-tabs autoCollapse><div wh-pane title="First Tab">First content is</div><div wh-pane title="Second Tab">Second content is</div></div>'
    scope = undefined
    compiledElm = undefined
    compiledElmLeftTabs = undefined
    compiledElmRightTabs = undefined
    compiledElmBottomTabs = undefined
    compiledElmCollapsibleTabs = undefined
    compiledElmAutoCollapsedTabs = undefined

    beforeEach module 'app'

    beforeEach inject (_$compile_, _$rootScope_, _$templateCache_, _$httpBackend_, _$controller_) ->
      scope = _$rootScope_
      compiledElm = _$compile_(testElm)(scope)
      compiledElmLeftTabs = _$compile_(testElmLeftTabs)(scope)
      compiledElmRightTabs = _$compile_(testElmRightTabs)(scope)
      compiledElmBottomTabs = _$compile_(testElmBottomTabs)(scope)
      compiledElmCollapsibleTabs = _$compile_(testElmCollapsibleTabs)(scope)
      compiledElmAutoCollapsedTabs = _$compile_(testElmAutoCollapsedTabs)(scope)
      scope.$digest()

    it 'should create clickable titles', () ->
      titles = compiledElm.find('ul.nav-tabs li a')

      expect(titles.length).toBe(2)
      expect(titles.eq(0).text()).toBe('First Tab')
      expect(titles.eq(1).text()).toBe('Second Tab')

    it 'should set active class on title', () ->
      titles = compiledElm.find('ul.nav-tabs li')

      expect(titles.eq(0).hasClass('active')).toBe(true)
      expect(titles.eq(1).hasClass('active')).not.toBe(true)

    it 'should change active pane when title clicked', () ->
      titles = compiledElm.find('ul.nav-tabs li')

      titles.eq(1).find('a').click()

      expect(titles.eq(0).hasClass('active')).not.toBe(true)
      expect(titles.eq(1).hasClass('active')).toBe(true)

    it 'should create left tabs', () ->
      expect(compiledElmLeftTabs.hasClass('tabs-left')).toBe(true)

    it 'should create right tabs', () ->
      expect(compiledElmRightTabs.hasClass('tabs-right')).toBe(true)

    it 'should create bottom tabs', () ->
      expect(compiledElmBottomTabs.hasClass('tabs-below')).toBe(true)

    it 'should create collapsible tabs', () ->
      # collapsible tab is expected to show the 'close pane' button(s) (inner div(s) with 'pull-right' class is/are not hidden)
      expect(compiledElmCollapsibleTabs.find('div.tab-content div.panel div.pull-right').hasClass('ng-hide')).toBe(false)

    it 'should hide pane upon click of close-panel link on collapsible tabs', () ->
      # initially, collapsible tab shows the first pane (first div with 'panel' class is not hidden)
      expect(compiledElmCollapsibleTabs.find('div.tab-content div.panel').eq(0).hasClass('ng-hide')).toBe(false)
      # simulate click of pane-close button of first pane
      compiledElmCollapsibleTabs.find('div.tab-content div.panel').eq(0).find('button.close').click()
      # after above click, the first pane is no more shown - it has 'collapsed' (first div with 'panel' class is now hidden)
      expect(compiledElmCollapsibleTabs.find('div.tab-content div.panel').eq(0).hasClass('ng-hide')).toBe(true)

    it 'should hide-n-show pane upon click of title of a tab on collapsible tabs', () ->
      # initially, collapsible tab shows the first pane (first div with 'panel' class is not hidden)
      expect(compiledElmCollapsibleTabs.find('div.tab-content div.panel').eq(0).hasClass('ng-hide')).toBe(false)
      # simulate click of title of first tab
      compiledElmCollapsibleTabs.find('ul.nav-tabs li').eq(0).find('a').click()
      # after above click, the first pane is no more shown - it has 'collapsed'(first div with 'panel' class is now hidden)
      expect(compiledElmCollapsibleTabs.find('div.tab-content div.panel').eq(0).hasClass('ng-hide')).toBe(true)
      # simulate a second click of title of first tab
      compiledElmCollapsibleTabs.find('ul.nav-tabs li').eq(0).find('a').click()
      # after above click, the first pane is once again shown - it has been 'un-collapsed' (first div with 'panel' class is no more hidden)
      expect(compiledElmCollapsibleTabs.find('div.tab-content div.panel').eq(0).hasClass('ng-hide')).toBe(false)

    it 'should create auto-collapsed tabs', () ->
      # auto-collapsed tab is expected to hide the panes initially (all div(s) with 'panel' class is/are hidden)
      expect(compiledElmAutoCollapsedTabs.find('div.tab-content div.panel').hasClass('ng-hide')).toBe(true)

    it 'should show-n-hide pane upon click of title of a tab on auto-collapsed tabs', () ->
      # initially, auto-collapsed tab hides the pane(s) (all div(s) with 'panel' class is/are hidden)
      expect(compiledElmAutoCollapsedTabs.find('div.tab-content div.panel').hasClass('ng-hide')).toBe(true)
      # simulate click of title of first tab
      compiledElmAutoCollapsedTabs.find('ul.nav-tabs li').eq(0).find('a').click()
      # after above click, the first pane is now shown - it has been 'un-collapsed' (first div with 'panel' class is no more hidden)
      expect(compiledElmAutoCollapsedTabs.find('div.tab-content div.panel').eq(0).hasClass('ng-hide')).toBe(false)
      # simulate a second click of title of first tab
      compiledElmAutoCollapsedTabs.find('ul.nav-tabs li').eq(0).find('a').click()
      # after above click, the first pane is no more shown - it has been 'collapsed' (first div with 'panel' class is now hidden)
      expect(compiledElmAutoCollapsedTabs.find('div.tab-content div.panel').eq(0).hasClass('ng-hide')).toBe(true)

    it 'should hide pane upon click of close-panel link on auto-collapsed tabs', () ->
      # initially, auto-collapsed tab hides the pane(s) (all div(s) with 'panel' class is/are hidden)
      expect(compiledElmAutoCollapsedTabs.find('div.tab-content div.panel').eq(0).hasClass('ng-hide')).toBe(true)
      # simulate click of title of first tab
      compiledElmAutoCollapsedTabs.find('ul.nav-tabs li').eq(0).find('a').click()
      # after above click, the first pane is now shown - it has been 'un-collapsed' (first div with 'panel' class is no more hidden)
      expect(compiledElmAutoCollapsedTabs.find('div.tab-content div.panel').eq(0).hasClass('ng-hide')).toBe(false)
      # simulate click of pane-close button of first pane
      compiledElmAutoCollapsedTabs.find('div.tab-content div.panel').eq(0).find('button.close').click()
      # after above click, the first pane is no more shown - it has 'collapsed' (first div with 'panel' class is now hidden)
      expect(compiledElmAutoCollapsedTabs.find('div.tab-content div.panel').eq(0).hasClass('ng-hide')).toBe(true)

