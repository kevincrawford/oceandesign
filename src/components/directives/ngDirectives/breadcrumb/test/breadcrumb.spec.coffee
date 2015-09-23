describe 'components', ->
  describe 'breadcrumb', ->

    scope = undefined
    authToken = JSON.parse('{"access_token":"r-A1Fd-wSxWfq0J6Sjd8ngcZGPmrZTnZsLD1OcgRcDUDDE8HQ_kYWAwRVvq6bdUhI2XFkEeQU2V1O9UYMFLWbA99b5gJEuONwulAANV6ondOhgjA2zE9QpV4Xogg7lit2IcmfjCSZbRmXXw8ovB_fohKezYH-Pb4ilOM1klHdfydjWOZvCSTHVhBua5CCUgvIMzoGM62oKNXMKkPnuBy54Y1PhyPjFuKWX-BuIrh0LTuEdjNTacYfNaIHEc820Q7ElxWfoeGtYF1DXibl0oNEDL29zZp-yIgat69pPQTqqxTncvXfi2p9NKA2sVSF9F8","token_type":"bearer","expires_in":59,"refresh_token":"f1b066e3ec7c4ceea60390b2dc80eec0","PersonPartyId":100621030}')

    breadcrumbHtml ='<dev><div wh-breadcrumb></div></div>'
    breadcrumbElem = undefined

    beforeEach module 'app'

    beforeEach inject (_$compile_, _$rootScope_, _$templateCache_, _$httpBackend_, _$controller_) ->
      scope = _$rootScope_.$new()
      breadcrumbElem = _$compile_(breadcrumbHtml)(scope)
      scope.$digest()

    it 'should not repalce html with breadcrumb directive tags if not authenticated', () ->
      # simulate non-authenticated scenario
      scope.isAuthenticated = false
      scope.$digest()
      expect(breadcrumbElem.find('ol.breadcrumb').length).toBe(0)

    it 'should repalce html with breadcrumb directive tags when authenticated', () ->
      # simulate authenticated scenario
      scope.isAuthenticated = true
      scope.$digest()
      expect(breadcrumbElem.find('ol.breadcrumb').length).toBe(1)
