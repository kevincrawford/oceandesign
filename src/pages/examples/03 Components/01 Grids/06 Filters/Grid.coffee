class GridFilter extends Controller
  constructor: ($q, $timeout, $sanitize, userDataFilterService) ->
    trim = /[ ]+/g
    @statusOptions = [
      { ItemCd: "Inactive", ItemDesc: "Inactive"}
      { ItemCd: "Active", ItemDesc: "Active"}
    ]
    @currentConfiguration =
    {
      columns: [
        { index: "FleetId", title: "Fleet", filterType: 'text' }
        { index: "JobTitle", title: "Job Title", filterType: 'text' }
        { index: "FirstName", title: "First", width: 150, filterType: 'text' }
        { index: "LastName", title: "Last", width: 150, filterType: 'text' }
        { index: "CreateDt", title: "Created Date", width: 150, filterType: 'dateRange' }
        { index: "Status", title: "Status", width: 150 }
        { index: "Points", title: "Points", width: 100, filterType: 'numberRange' }
        { index: "Unfilterable", title: "Unfilterable", width: 150 }
      ]
      filters: { }
      dataSource: userDataFilterService.getData
    }
    @selected = null
    @displayed = null
    @filter = { }