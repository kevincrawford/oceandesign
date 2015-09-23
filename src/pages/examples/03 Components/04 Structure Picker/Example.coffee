class ExampleStructurePicker extends Controller
  constructor: ($http, $templateCache, $scope) ->
    @showInactive = false
    @selectAll = false
    @filter = ""
    @selected = []
    @data = []
    @selectAll = null
    @deselectAll = null
    @expandAll = null
    @collapseAll = null
    @unselect = (item) =>
      @selected = (i for i in @selected when item.id != i.id)

    $scope.$watch 'c.showInactive', => @showInactiveText = if @showInactive then "Show Active" else "Show Inactive"

    @savedFilters = [] # load this from server
    @loadSavedFilter = (filter) =>
      @selected = filter.Selected

    @divisionFilterCancel = =>
      @showDivisionFilterSave = false
      @divisionFilterName = ""
    @divisionFilterSave = =>
      @savedFilters.push
        Name: @divisionFilterName
        Selected: { id: i.id } for i in @selected

    $http
    .get 'pages/examples/03 Components/04 Structure Picker/large.json', cache: $templateCache
    .success (d,s,h,c) => @data = d
