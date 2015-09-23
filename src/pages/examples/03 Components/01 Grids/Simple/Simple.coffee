class SimpleTable extends Controller
	constructor: ($q, $timeout, $sanitize) ->
		@formatter = (value, rowValue, columnDefinition) ->
			# protect us from XSS
			styleValue = value.replace(/[^A-Za-z0-9#]/, "")
			"<div style='background: " + styleValue + ";'>" + $sanitize(value) + "</div>";
		# this should actually be your back-end service that uses the sort/filter information to trim the information returned
		@dataSource = (sort, filter) ->
			result = $q.defer()
			$timeout () ->
				data = [
					{ title: 'foo', value: "something", color: "red" }
					{ title: 'bar', value: "another thing", color: "green" }
					{ title: 'four', value: "even other things", color: "blue" }
				]
				if sort && sort.column == "title"
					if sort.direction == "asc"
						data.sort (a,b) -> if a.title < b.title then -1 else if a.title > b.title then 1 else 0
					if sort.direction == "desc"
						data.sort (b,a) -> if a.title < b.title then -1 else if a.title > b.title then 1 else 0
				result.resolve data
			result.promise
		#start with nothing selected
		@selected = null