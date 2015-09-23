describe 'components', ->
  describe 'validation', ->
    describe 'whDatePattern', ->
      scope = undefined
      form = undefined
      dateValue = undefined

      beforeEach module 'app'

      beforeEach inject ($compile, $rootScope) ->
        linkingFunction = $compile('<form name="someForm"><input ng-model="model.someDate" name="someDateInput" wh-date-pattern></form>')
        scope = $rootScope
        scope.model = { someDate: null }
        linkingFunction(scope)
        form = scope.someForm

      it 'should validate true with date format mm/dd/yyyy for valid month', () ->
        dateValue = '01/15/2014'
        form.someDateInput.$setViewValue(dateValue)
        scope.$digest()
        expect(scope.model.someDate).toEqual(dateValue)
        expect(form.someDateInput.$valid).toBeTruthy()
        dateValue = '09/15/2014'
        form.someDateInput.$setViewValue(dateValue)
        scope.$digest()
        expect(scope.model.someDate).toEqual(dateValue)
        expect(form.someDateInput.$valid).toBeTruthy()
        dateValue = '10/15/2014'
        form.someDateInput.$setViewValue(dateValue)
        scope.$digest()
        expect(scope.model.someDate).toEqual(dateValue)
        expect(form.someDateInput.$valid).toBeTruthy()
        dateValue = '12/15/2014'
        form.someDateInput.$setViewValue(dateValue)
        scope.$digest()
        expect(scope.model.someDate).toEqual(dateValue)
        expect(form.someDateInput.$valid).toBeTruthy()

      it 'should validate true with date format mm/dd/yyyy for valid day', () ->
        dateValue = '01/01/2014'
        form.someDateInput.$setViewValue(dateValue)
        scope.$digest()
        expect(scope.model.someDate).toEqual(dateValue)
        expect(form.someDateInput.$valid).toBeTruthy()
        dateValue = '01/31/2014'
        form.someDateInput.$setViewValue(dateValue)
        scope.$digest()
        expect(scope.model.someDate).toEqual(dateValue)
        expect(form.someDateInput.$valid).toBeTruthy()

      it 'should validate true with date format mm/dd/yyyy for valid year', () ->
        dateValue = '01/01/1900'
        form.someDateInput.$setViewValue(dateValue)
        scope.$digest()
        expect(scope.model.someDate).toEqual(dateValue)
        expect(form.someDateInput.$valid).toBeTruthy()
        dateValue = '01/31/2099'
        form.someDateInput.$setViewValue(dateValue)
        scope.$digest()
        expect(scope.model.someDate).toEqual(dateValue)
        expect(form.someDateInput.$valid).toBeTruthy()

      it 'should validate false with date format mm/dd/yyyy for invalid month', () ->
        dateValue = '00/15/2014'
        form.someDateInput.$setViewValue(dateValue)
        scope.$digest()
        expect(form.someDateInput.$valid).toBeFalsy()
        dateValue = '13/15/2014'
        form.someDateInput.$setViewValue(dateValue)
        scope.$digest()
        expect(form.someDateInput.$valid).toBeFalsy()

      it 'should validate false with date format mm/dd/yyyy for invalid day', () ->
        dateValue = '01/00/2014'
        form.someDateInput.$setViewValue(dateValue)
        scope.$digest()
        expect(form.someDateInput.$valid).toBeFalsy()
        dateValue = '01/32/2014'
        form.someDateInput.$setViewValue(dateValue)
        scope.$digest()
        expect(form.someDateInput.$valid).toBeFalsy()

      it 'should validate false with date format mm/dd/yyyy for invalid year', () ->
        dateValue = '01/01/1899'
        form.someDateInput.$setViewValue(dateValue)
        scope.$digest()
        expect(form.someDateInput.$valid).toBeFalsy()
        dateValue = '01/01/2100'
        form.someDateInput.$setViewValue(dateValue)
        scope.$digest()
        expect(form.someDateInput.$valid).toBeFalsy()

      it 'should validate false with date format yy/mm/dd', () ->
        dateValue = '14/01/14'
        form.someDateInput.$setViewValue(dateValue)
        scope.$digest()
        expect(form.someDateInput.$valid).toBeFalsy()

      it 'should validate false with date format mm-dd-yyyy', () ->
        dateValue = '10-15-2014'
        form.someDateInput.$setViewValue(dateValue)
        scope.$digest()
        expect(form.someDateInput.$valid).toBeFalsy()