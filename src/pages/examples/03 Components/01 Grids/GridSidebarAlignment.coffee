class GridSidebarAlignment extends Controller
  constructor: ($q, $timeout, $sanitize, userDataService) ->
    trim = /[ ]+/g
    @configs =[
      {
        name: "Active"
        columns: [
          { index: "FleetId", title: "Left", align: 'center', align: 'left' }
          { index: "FirstName", title: "Right", width: 150, align: 'right' }
          { index: "LastName", title: "Right with a pretty long name", width: 150, align: 'right' }
          { index: "JobTitle", title: "Left", align: 'left' }
          { index: "LastName2", title: "Right", align: 'right' }
          { index: "JobTitle2", title: "Left", align: 'left' }
        ]
        filters: {
          status: "Active"
        }
        dataSource: userDataService.getData
      }
    ]
    @currentConfiguration = @configs[0]
    @selected = null
    @displayed = null