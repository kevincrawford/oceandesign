class WhDesignDebounce extends Directive
	# https://gist.github.com/tommaitland/7579618, since ngModelOptions isn't available in angular 1.2 :(
	constructor: ($timeout) ->
		return {
			restrict: "A"
			require: "ngModel"
			priority: 99
			link: (scope, elm, attr, ngModelCtrl) ->
				return  if attr.type is "radio" or attr.type is "checkbox"
				elm.unbind "input"
				debounce = null
				elm.bind "input", ->
					$timeout.cancel debounce if debounce
					debounce = $timeout ->
						scope.$apply ->
							ngModelCtrl.$setViewValue elm.val()
					, attr.debounce or 1000

				elm.bind "blur", ->
					scope.$apply ->
						ngModelCtrl.$setViewValue elm.val()
		}
