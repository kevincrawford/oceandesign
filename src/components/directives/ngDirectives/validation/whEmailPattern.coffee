class whEmailPattern extends Directive
  constructor: () ->
    link = (scope, element, attrs, model) ->
      re = /^(\w+)([\-.'~][\w]+)*@(\w[\-\w]*\.){1,5}([A-Za-z]){2,6}$/
      spaceRegex = /\s/
      validateEmail = (value) ->
        if value and not re.test(value) and not spaceRegex.test value
          model.$setValidity 'pattern',false
          return undefined
        else if value and spaceRegex.test value
          model.$setValidity 'whitespace',false
          return undefined
        else
          model.$setValidity 'pattern',true
          model.$setValidity 'whitespace',true
          return value
      model.$parsers.push validateEmail
      model.$formatters.push validateEmail
    return {
    require : 'ngModel'
    link

    }