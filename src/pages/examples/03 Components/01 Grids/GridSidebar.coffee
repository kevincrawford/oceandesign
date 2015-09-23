class GridSidebar extends Controller
	constructor: ($q, $timeout, $sanitize, userDataService) ->
		trim = /[ ]+/g
		@freeTextFilter = value: ""
		@freeTextColumns = ['FirstName', 'LastName']
		@configs =[
			{
				name: "Active"
				columns: [
					{ index: "FleetId", title: "Fleet" }
					{ index: "JobTitle", title: "Job Title" }
					{ index: "FirstName", title: "First", width: 150 }
					{ index: "LastName", title: "Last", width: 150 }
				]
				filters: {
					status: "Active"
					freeText: @freeTextFilter
					freeTextColumns: @freeTextColumns
				}
				dataSource: userDataService.getData
			}
			{
				name: "Not Active"
				columns: [
					{ index: "FleetId", title: "Fleet" }
					{ index: "DivisionCd", title: "Division" }
					{ index: "FullName", title: "Name", width: 300 }
				]
				filters: {
					status: "Inactive"
					freeText: @freeTextFilter
					freeTextColumns: @freeTextColumns
					fleetId: ""
				}
				dataSource: userDataService.getData
			}
			{
				name: "No Job Title"
				columns: [
					{ index: "FleetId", title: "Fleet" }
					{ index: "DivisionCd", title: "Division" }
					{ index: "FullName", title: "Name", width: 300 }
				]
				filters: {
					jobTitle: ""
					fleetId: ""
				}
				dataSource: userDataService.getData
			}
			{
				name: "Not Active and Job Title"
				columns: [
					{ index: "FleetId", title: "Fleet" }
					{ index: "DivisionCd", title: "Division" }
					{ index: "JobTitle", title: "JobTitle" }
					{ index: "FullName", title: "Name", width: 300 }
				]
				filters: {
					jobTitle: "<hasvalue>"
					status: "Inactive"
				}
				filterFunction: (i) -> (i.JobTitle || "").replace(trim,"") != "" && (i.UserPickItem || {}).Status != "Active"
				dataSource: userDataService.getData
			}
		]
		@currentConfiguration = @configs[0]
		@selected = null
		@displayed = null