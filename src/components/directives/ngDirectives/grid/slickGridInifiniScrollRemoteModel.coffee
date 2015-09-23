class SlickGridInfiniScrollRemoteModel extends Service
	constructor: ($timeout, $q, $log) ->
		@create = () ->
			configuration =
				dataSource: () ->
					[]
			sort = null
			pageSize = 50
			changeSettings = (newConfiguration, newSort) ->
				configuration = newConfiguration
				sort = newSort
				pageSize = configuration.pageSize || pageSize
				clear()
			data =
				length: 0
			activeRequest = null
			pendingRequest = null
			onDataLoading = new Slick.Event()
			onDataLoaded = new Slick.Event()
			onDataClear = new Slick.Event()

			isDataLoaded = (from, to) ->
				for i in [from..to]
					return false if !data[i]?
				true

			clear = () ->
				for k of data
					delete data[k] unless k == 'getItemMetadata'
				data.length = 0
				onDataClear.notify()

			ensureData = (from, to) ->
				#$log.debug "ensureData", from, to
				if activeRequest
					if configuration.dataSource.cancel
						configuration.dataSource.cancel activeRequest.promise
					for i in [activeRequest.fromPage..activeRequest.toPage]
						data[i * pageSize] = undefined
				if from < 0 then from = 0
				if data.length > 0 then to = Math.min(to, data.length-1)
				fromPage = Math.floor(from / pageSize)
				toPage = Math.floor(to / pageSize)
				while data[fromPage * pageSize] != undefined && fromPage < toPage
					fromPage++
				while data[toPage * pageSize] != undefined && fromPage < toPage
					toPage--;
				#$log.debug "ensureData - pages", fromPage, toPage
				if fromPage > toPage || ((fromPage == toPage) && data[fromPage * pageSize] != undefined)
					onDataLoaded.notify from: from, to: to
					return

				if pendingRequest
					$timeout.cancel pendingRequest

				pendingRequest = $timeout () ->
					#$log.debug "pendingRequest loading"
					data[i * pageSize] = null for i in [fromPage..toPage]
					onDataLoading.notify from: from, to: to
					start = fromPage * pageSize
					limit = (toPage - fromPage) * pageSize + pageSize
					activeRequest = {
						promise: configuration.dataSource(configuration: configuration, sort: sort, start: start, limit: limit, filters: configuration.filters)
						fromPage: fromPage
						toPage : toPage
					}
					$q.when(activeRequest.promise).then onSuccess
				, 50

			onSuccess = (resp) ->
				#$log.debug "pre", resp
				if angular.isArray(resp) # if we get an array, we assume the datasource/server doesn't know about paging, but still knows about filter/sort
					resp = start: 0, results: resp, total: resp.length
				#$log.debug resp
				from = +resp.start
				to = from + resp.results.length
				expectedTo = +resp.start + pageSize
				data.length = resp.total || if expectedTo > to then to else to + pageSize
				for i,v of resp.results
					data[from + +i] = v
					data[from + +i].index = from + i
				activeRequest = null
				#$log.debug data
				onDataLoaded.notify from: from, to: to

			reloadData = (from, to) ->
				delete data[i] for i in [from..to]
				ensureData from, to

			return {
				changeSettings: changeSettings
				data: data
				clear: clear
				isDataLoaded: isDataLoaded
				ensureData: ensureData
				reloadData: reloadData
				onDataLoading: onDataLoading
				onDataLoaded: onDataLoaded
				onDataClear: onDataClear
			}
