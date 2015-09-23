class whDatePattern extends Directive
  constructor: () ->
    link = (scope, element, attrs, model) ->
      #re = /^(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.](19|20)\d\d$/
      re = /(0[1-9]|1[012])[\/](0[1-9]|[12][0-9]|3[01])[\/](19|20)\d\d/
      #element.bind
      validator = (value) ->
        if !value or re.test value
          model.$setValidity 'pattern',true
          return value
          #alert 'success'
        else
          model.$setValidity 'pattern',false
          return undefined
          #alert 'failure'
      model.$parsers.push validator
      model.$formatters.push validator
    return {
    require : 'ngModel'
    link

    }