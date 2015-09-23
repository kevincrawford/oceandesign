describe 'whPhonePattern', ->
  scope = undefined
  form = undefined

  beforeEach module 'app'

  beforeEach inject ($compile, $rootScope) ->
    linkingFunction = $compile('<form name="someForm"><input ng-model="model.phoneNumber" name="somePhoneNumber" wh-phone-pattern></form>')
    scope = $rootScope.$new()
    scope.model = { phoneNumber: null }
    linkingFunction(scope)
    form = scope.someForm

  it 'should validate to true with valid phone number formats', () ->
    # no delimiters
    form.somePhoneNumber.$setViewValue('7033395015')
    scope.$digest()
    expect(scope.model.phoneNumber).toEqual('7033395015')
    expect(form.somePhoneNumber.$valid).toBeTruthy()
    # hyphen as delimiter
    form.somePhoneNumber.$setViewValue('703-339-5015')
    scope.$digest()
    expect(scope.model.phoneNumber).toEqual('7033395015')
    expect(form.somePhoneNumber.$valid).toBeTruthy()
    # dot as delimiter
    form.somePhoneNumber.$setViewValue('703.339.5015')
    scope.$digest()
    expect(scope.model.phoneNumber).toEqual('7033395015')
    expect(form.somePhoneNumber.$valid).toBeTruthy()
    # brackets around area code and dot as delimiter
    form.somePhoneNumber.$setViewValue('(703)339.5015')
    scope.$digest()
    expect(scope.model.phoneNumber).toEqual('7033395015')
    expect(form.somePhoneNumber.$valid).toBeTruthy()
    form.somePhoneNumber.$setViewValue('(703)339-5015')
    scope.$digest()
    expect(scope.model.phoneNumber).toEqual('7033395015')
    # brackets around area code, space and dot as delimiter
    expect(form.somePhoneNumber.$valid).toBeTruthy()
    form.somePhoneNumber.$setViewValue('(703) 339.5015')
    scope.$digest()
    expect(scope.model.phoneNumber).toEqual('7033395015')
    expect(form.somePhoneNumber.$valid).toBeTruthy()
    # brackets around area code, space and hyphen as delimiter
    form.somePhoneNumber.$setViewValue('(703) 339-5015')
    scope.$digest()
    expect(scope.model.phoneNumber).toEqual('7033395015')
    expect(form.somePhoneNumber.$valid).toBeTruthy()

  it 'should validate to false with a phone number in the wrong format', () ->
    form.somePhoneNumber.$setViewValue('70-3339-5015')
    scope.$digest()
    expect(form.somePhoneNumber.$valid).toBeFalsy()

#  it 'should validate to false with a phone number that is more than 10 digits', () ->
#    form.somePhoneNumber.$setViewValue('703333242395015')
#    scope.$digest()
#    expect(form.somePhoneNumber.$valid).toBeFalsy()
#
#  it 'should validate to false with a phone number that is less than 10 digits', () ->
#    form.somePhoneNumber.$setViewValue('70015')
#    scope.$digest()
#    expect(form.somePhoneNumber.$valid).toBeFalsy()

  it 'should validate to false with a phone number that contains invalid characters', () ->
    form.somePhoneNumber.$setViewValue('asdf@#$')
    scope.$digest()
    expect(form.somePhoneNumber.$valid).toBeFalsy()