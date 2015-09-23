class whGlobalSearch extends Directive
	constructor: (globalSearchService) ->

		link = (scope, element, attrs) =>
			scope.loading = false
			scope.focused = false
			scope.mouseover = false
			scope.text = ""
			scope.results = []
			scope.active = () => (scope.focused || scope.mouseover) && scope.text
			scope.$watch "text", () =>
				scope.loading = true
				globalSearchService.search scope.text
					.then (data) ->
						scope.results = data
						scope.loading = false

		return {
			link
			replace: true
			restrict: 'A'
			templateUrl: 'components/directives/ngDirectives/globalSearch/whGlobalSearch.html'
		}