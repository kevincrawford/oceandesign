class UserData extends Service
	constructor: ($q, $http, $templateCache, $log) ->
		trim = /[ ]+/g
		@getData = (request) ->
			$log.debug request
			result = $q.defer()
			$log.debug "Requesting", request
			# use the information from request.configuration, request.sort, request.start, and request.length to build and send the request to the server
			# here, we're fetching the full set of data from the server and doing the filter, sort, and paging locally.  DO NOT DO THIS WITH REAL DATA - DELEGATE THE WORK TO THE SERVER SERVICE
			$http
				.get "pages/examples/03 Components/01 Grids/userData.json", cache: $templateCache
				.then (d) ->
					# copy a few filters from the upper-case version to the lower-case version
					request.filters.jobTitle = request.filters.jobTitle || request.filters.JobTitle
					request.filters.fleetId = request.filters.fleetId || request.filters.FleetId
					filter = (item) ->
						if (request.filters.status == "Active" || (request.filters.Status?.length && (i for i in request.filters.Status when i.ItemCd == "Active").length )) && (item.UserPickItem || {}).Status != "Active"
							return false
						if (request.filters.status == "Inactive" || (request.filters.Status?.length && (i for i in request.filters.Status when i.ItemCd == "Inactive").length )) && (item.UserPickItem || {}).Status == "Active"
							return false
						if request.filters.jobTitle == "" && (item.JobTitle || "").replace(trim, "") != ""
							return false
						if request.filters.jobTitle == "<hasvalue>" && (item.JobTitle || "").replace(trim, "") == ""
							return false
						if request.filters.fleetId && (item.FleetId || "").toLowerCase().indexOf(request.filters.fleetId.toLowerCase()) < 0
							return false
						if request.filters.freeText && request.filters.freeText.value && request.filters.freeTextColumns
							parts = request.filters.freeText.value.toLowerCase().split /\s/
							for p in parts
								found = false
								for col in request.filters.freeTextColumns
									colParts = col.split /\./
									val = item
									for cp in colParts
										val = (val || {})[cp]
									if val && (val + "").toLowerCase().indexOf(p) >= 0
										found = true
								if !found
									return false
						true

					data = for i in d.data.PersonPickItems when filter i
						i
					if request.sort && request.sort.Field && request.sort.SortDirection
						data.sort (a,b) ->
							a = a[request.sort.Field]
							b = b[request.sort.Field]
							if request.sort.SortDirection == 2
								c = a
								a = b
								b = c
							if a < b then -1 else if a > b then 1 else 0
					result.resolve {
						total: data.length
						start: request.start
						results: data.slice request.start, request.start + request.limit
					}
				, (reason) ->
					result.reject reason
			result.promise
#					configuration, sort
