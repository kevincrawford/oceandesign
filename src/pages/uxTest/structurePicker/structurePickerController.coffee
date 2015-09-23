class StructurePicker extends Controller
  constructor: ($http, $templateCache, $scope, @structurePickerService, @$q) ->
    @showInactive = false
    @selectAll = false
    @filter = ""
    @selected = @structurePickerService.getCurrent()
    @data = []
    @selectAll = null
    @deselectAll = null
    @expandAll = null
    @collapseAll = null
    @unselect = (item) =>
      @selected = (i for i in @selected when item.id != i.id)

    $scope.$watch 'c.showInactive', => @showInactiveText = if @showInactive then "Hide Inactive" else "Show Inactive"

    @savedFilters = null
    @structurePickerService.loadSavedFilters().then (v) => @savedFilters = v
    @loadSavedFilter = (filter) =>
      @selected = filter.Selected

    @applying = false
    @applied = false
    @isSaving = false

    @apply = =>
      @applying = true
      p = @structurePickerService.apply @selected
      p.then =>
        @applying = false
        @applied = true
        @structurePickerService.hide()
      , =>
        # error - should probably say something...
        @applying = false
        @isSaving = false

    @doSave = =>
      d = @$q.defer()
      setTimeout =>
        @savedFilters.push
          Name: @divisionFilterName
          Selected: { id: i.id } for i in @selected
        d.resolve()
      , 1000
      d.promise

    @divisionFilterSave = =>
      @applying = true
      @isSaving = true
      @structurePickerService.save(@divisionFilterName, { id: i.id } for i in @selected).then =>
        @apply()
      , =>
        # error - should probably say something...
        @applying = false
        @isSaving = false

    $http
    .get 'pages/examples/03 Components/04 Structure Picker/large.json', cache: $templateCache
    .success (d,s,h,c) => @data = d
  close: -> @structurePickerService.hide()
