class whSimpleTable extends Directive
	constructor: ($q, $sce) ->
		link = (scope, element, attrs) =>
			scope.setSort = (ix) ->
				if scope.sort == ix
					scope.sortDir = if scope.sortDir == "asc" then "desc" else "asc"
				else
					scope.sort = ix
					scope.sortDir = "asc"
			# make $sce.trustAsHtml available to the template
			scope.trustAsHtml = (v) -> $sce.trustAsHtml v
			scope.data = []
			setup = () ->
				scope.selected = null
				ds = scope.source
				sort = if scope.sort then column: scope.sort, direction: scope.sortDir
				$q.when o = (ds?(sort, scope.filter) ? ds) # if ds is a function, we call it with the sort/filter, otherwise we'll just assume it's an array or promise wrapping an array
				.then (r) ->
					scope.data = r; if r.length > 0 then scope.selected = r[0]

			#default sort field and direction
			if !scope.sort then scope.sort = scope.columns[0].index
			if !scope.sortDir then scope.sortDir = "asc"

			scope.$watch 'source', setup
      # commented out the code for now, so that we have only one API call
			#scope.$watch 'filter', setup
			#scope.$watch 'sort', setup
			#scope.$watch 'sortDir', setup
			scope.$watch 'selected', () ->
				if attrs.selected
					scope.$eval attrs.selected + ' = selected'
			# we don't support the consumer setting the selected item yet
			#scope.$watch attrs.selected, (v) ->

			setup

		return {
			link
			replace: true
			restrict: 'A'
			templateUrl: "components/directives/ngDirectives/simpleTable/whSimpleTable.html"
			scope:
				columns: '=columns'
				source: '=source' # can be: a function that returns an array, a function that returns a promise of an array, an array, or a promise of an array.  If it's a function, it's called with the sort and filter information as arguments
				selected: '=?selected'
				filter: '=?filter'
				sort: '=?sort'
				sortDir: '=?sortDir'
		}