class GlobalSearch extends Service
	constructor: ($route, $http, $templateCache, $q) ->
		any = (arr, f) ->
			(return true if f x) for x in arr
			return false
		@search = (query) =>
			query = query.toLowerCase()
			items = []
			for k, v of $route.routes
				if v.label && k
					do(k,v) ->
						pageTags =
							if v.tags || !v.tagsFile
								$q.when v.tags || []
							else
								$http .get(v.tagsFile, { cache: $templateCache }).then (d) ->
									d.data.split(/\r?\n/)
						items.push pageTags.then (tags) -> label: v.label, href: k, tags: tags
						if v.examples
							for vv in v.examples
								exTags =
									if vv.tags || !vv.tagsFile
										$q.when vv.tags || []
									else
										$http .get(vv.tagsFile, { cache: $templateCache }).then (d) ->
											d.data.split(/\r?\n/)
								items.push $q.all([pageTags, exTags]).then (allTags) ->
									label: v.label + ": " + vv.title, href: k, tags: allTags[0].concat allTags[1]
			$q.all items
			.then (items) ->
				item for item in items when item.label.toLowerCase().indexOf(query) >= 0 || any(item.tags, (t) -> t.toLowerCase().indexOf(query) >= 0)
