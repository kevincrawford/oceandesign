describe 'whEmailPattern', ->
  scope = undefined
  form = undefined

  beforeEach module 'app'

  beforeEach inject ($compile, $rootScope) ->
    linkingFunction = $compile('<form name="someForm"><input ng-model="model.emailAddress" name="someEmailAddress" wh-email-pattern></form>')
    scope = $rootScope
    scope.model = { emailAddress: null }
    linkingFunction(scope)
    form = scope.someForm

  it 'should validate to true with email address', () ->
    form.someEmailAddress.$setViewValue('billybob@wheels.com')
    scope.$digest()
    expect(scope.model.emailAddress).toEqual('billybob@wheels.com')
    expect(form.someEmailAddress.$valid).toBeTruthy()

  it 'should validate to false with email address that is missing @', () ->
    form.someEmailAddress.$setViewValue('billybobwheels.com')
    scope.$digest()
    expect(form.someEmailAddress.$valid).toBeFalsy()

  it 'should validate to false with email address that has a single character in each section', () ->
    form.someEmailAddress.$setViewValue('b@s.m')
    scope.$digest()
    expect(form.someEmailAddress.$valid).toBeFalsy()

  it 'should validate to false with email address that has greater than 6 characters in the last section', () ->
    form.someEmailAddress.$setViewValue('basdf@sasdf.mafasd5')
    scope.$digest()
    expect(form.someEmailAddress.$valid).toBeFalsy()

  it 'should validate to false with email address containing special characters other than ~ or -', () ->
    form.someEmailAddress.$setViewValue('billy$bob@wheels.com')
    scope.$digest()
    expect(form.someEmailAddress.$valid).toBeFalsy()

  it 'should validate to true with email address containing special characters ~ or -', () ->
    form.someEmailAddress.$setViewValue('b~lly-bob@wheels.com')
    scope.$digest()
    expect(form.someEmailAddress.$valid).toBeTruthy()