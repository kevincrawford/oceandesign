class GridSidebarSpecial extends Controller
  constructor: ($q, $timeout, $sanitize, userDataService) ->
    @linkFormatter = (row, cell, value, columnDef, dataContext) =>
      '<div class="wh-grid-link" data-row="' + row + '">' + value + '</div>'
    @click = (e, data) =>
      tgt = angular.element(e.target)
      if tgt.is(".wh-grid-link")
        alert data[tgt.data("row")].LastName

    trim = /[ ]+/g
    @freeTextFilter = value: ""
    @freeTextColumns = ['FirstName', 'LastName']
    @configs =[
      {
        name: "Active"
        columns: [
          { index: "FleetId", title: "Fleet Id", align: 'center', align: 'left' }
          { index: "FirstName", title: "First", width: 150, formatter: @linkFormatter }
          { index: "LastName", title: "Last", width: 150 }
        ]
        filters: {
          status: "Active"
          freeText: @freeTextFilter
          freeTextColumns: @freeTextColumns
        }
        dataSource: userDataService.getData
      }
    ]
    @currentConfiguration = @configs[0]
    @selected = null
    @displayed = null