class whPhonePattern extends Directive
  constructor: ($log) ->
    link = (scope, element, attrs, model) ->
      phoneRegEx = /^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/
      replaceEx = '($1)$2-$3'
      #element.bind
      parseNValidate = (viewValue) ->
        if !viewValue
          model.$setValidity 'pattern',true
          return viewValue
        if phoneRegEx.test viewValue
          model.$setValidity 'pattern',true
          model.$viewValue = viewValue.replace(phoneRegEx, replaceEx)
          model.$render()
          $log.debug 'View Value : ' + model.$viewValue
          return viewValue.replace(phoneRegEx, "$1$2$3")
        else
          model.$setValidity 'pattern',false
          return undefined


      formatter = (modelValue) ->
        if modelValue and phoneRegEx.test modelValue
          $log.debug 'I received ' + modelValue
          model.$setValidity 'pattern',true
          formattedVal = modelValue.replace(phoneRegEx, replaceEx)
          $log.debug 'I formatted ' + formattedVal
          return formattedVal
        else
          $log.debug 'not valid value to format (' + modelValue + ')'

      model.$parsers.push parseNValidate
      model.$formatters.push formatter

    return {
    require : 'ngModel'
    link
    }
