describe 'components', ->
  describe 'script', ->
    describe 'scriptService', ->

      scope = undefined
      myService = undefined

      beforeEach module 'app'

      beforeEach inject (_$rootScope_, scriptService) ->
        scope =  _$rootScope_
        myService = scriptService

      it 'should instantiate service', ->
        expect(myService).not.toBeUndefined()

      xit 'should verify service attributes are populated', ->
        # TODO: write test here to verify prepopulated data within the service ("scriptService.url","scriptService.prefix", and "scriptService.doc")

      xit 'should provide valid list of scripts', ->
        # TODO: write test here to verify 'scriptService.get()' operation

      xit 'should be able to add an element to list of scripts', ->
        # TODO: write test here to verify 'scriptService.add()' operation
