class FilterSave extends Controller
  constructor: ($scope, @filterDescriptionService) ->
    lists = {"VehicleContactRoleList":[{"ItemCd":"2","ItemDesc":"Contact"},{"ItemCd":"1","ItemDesc":"Driver"}],"UnitTypeList":[{"ItemCd":"C","ItemDesc":"Compact"},{"ItemCd":"F","ItemDesc":"Foreign"},{"ItemCd":"4","ItemDesc":"Fork Lift"},{"ItemCd":"H","ItemDesc":"Hearse"},{"ItemCd":"3","ItemDesc":"Heavy Truck"},{"ItemCd":"I","ItemDesc":"Intermediate"},{"ItemCd":"1","ItemDesc":"Light Truck"},{"ItemCd":"N","ItemDesc":"Limousine"},{"ItemCd":"L","ItemDesc":"Luxury"},{"ItemCd":"2","ItemDesc":"Medium Truck"},{"ItemCd":"M","ItemDesc":"Minivan"},{"ItemCd":"7","ItemDesc":"Motorhome/Camper"},{"ItemCd":"9","ItemDesc":"Non-vehicular Equipment"},{"ItemCd":"R","ItemDesc":"Regular"},{"ItemCd":"S","ItemDesc":"Specialty Car"},{"ItemCd":"W","ItemDesc":"Station Wagon"},{"ItemCd":"T","ItemDesc":"Sub-compact"},{"ItemCd":"8","ItemDesc":"SUV"},{"ItemCd":"6","ItemDesc":"Tractor"},{"ItemCd":"5","ItemDesc":"Trailer"}],"VehicleApplicationList":[{"ItemCd":"10","ItemDesc":"Basic Transport"},{"ItemCd":"12","ItemDesc":"Equipment"},{"ItemCd":"7","ItemDesc":"Executive"},{"ItemCd":"11","ItemDesc":"Law Enforcement"},{"ItemCd":"14","ItemDesc":"N/A"},{"ItemCd":"13","ItemDesc":"Other"},{"ItemCd":"9","ItemDesc":"Plant/Site"},{"ItemCd":"6","ItemDesc":"Sales - Management"},{"ItemCd":"5","ItemDesc":"Sales - National"},{"ItemCd":"4","ItemDesc":"Sales - Territory"},{"ItemCd":"1","ItemDesc":"Service - Call Response"},{"ItemCd":"3","ItemDesc":"Service - Management"},{"ItemCd":"8","ItemDesc":"Service - Project"},{"ItemCd":"2","ItemDesc":"Service - Route/Delivery"},{"ItemCd":"-9999","ItemDesc":"Unknown"}]}

    @timeFrameOptions = [
      {ItemCd:1,ItemDesc:'12 MONTHS (1 YEAR)'}
      {ItemCd:2,ItemDesc:'24 MONTHS (2 YEARS)'}
      {ItemCd:3,ItemDesc:'36 MONTHS (3 YEARS)'}
      {ItemCd:4,ItemDesc:'Enter Custom Dates'}
    ]

    @contactRoleOptions = lists.VehicleContactRoleList
    @vehicleRelationshipOptions = [{ItemCd:"2",ItemDesc:"UNASSIGNED"},{ItemCd:"1",ItemDesc:"ASSIGNED"}]
    @unitTypeOptions = lists.UnitTypeList
    @applicationCodeOptions = lists.VehicleApplicationList

    sortOptions = (a,b) -> if a.ItemDesc < b.ItemDesc then -1 else if a.ItemDesc > b.ItemDesc then 1 else 0
    @contactRoleOptions.sort sortOptions
    @vehicleRelationshipOptions.sort sortOptions
    @unitTypeOptions.sort sortOptions
    @applicationCodeOptions.sort sortOptions

    @defaultFilters =
      timeFrame: @timeFrameOptions[0]
      timeFrameStart: null
      timeFrameEnd: null
      contactRole: null
      vehicleRelationship: null
      unitType: ((j for j in @unitTypeOptions when j.ItemCd == i)[0] for i in "CFH3I1NL2M7RSWT8")
      applicationCode: angular.copy @applicationCodeOptions

    @filters = angular.copy @defaultFilters

    @applyFilters = =>
      @appliedFilters = angular.copy(@filters)

      # make a copy of the filters with the null/undefined filters removed
      f = angular.copy(@appliedFilters)
      delete f[k] for k in (k for k,v of f when !v?)
      # update the description
      @appliedFiltersDescription = @filterDescriptionService.getDescription(f, @filtersFields, @filtersDescriptionConfig)
    @clearFilters = =>
      @filters = angular.copy @defaultFilters
      @applyFiltersAndRefinements()
    @saveFilters = =>
      @savedFilters.push { name: Math.random(), data: angular.copy(@filters) }

    @applyFilter = (item) =>
      @filters = angular.copy(item.data)
      @applyFilters()
    @deleteFilter = (item) =>
      @savedFilters = (i for i in @savedFilters when i.name != item.name)
    @scheduleFilter = (item) =>

    # used to build descriptions of the fields with the filter description service
    @filtersFields = [
      { ItemCd: 'timeFrame', ItemDesc: 'Time Frame'}
      { ItemCd: 'contactRole', ItemDesc: 'Contact Role' }
      { ItemCd: 'vehicleRelationship', ItemDesc: 'Vehicle Relationship' }
      { ItemCd: 'unitType', ItemDesc: 'Unit Type' }
      { ItemCd: 'applicationCode', ItemDesc: 'Application Code'}
    ]

    # used to override building the descriptions of the fields with the filter description service
    @filtersDescriptionConfig =
      timeFrameStart: -> null
      timeFrameEnd: -> null
      timeFrame: (value, filters) ->
        if value.ItemCd == 4
          value.ItemDesc + ": " + filters.timeFrameStart + " to " + filters.timeFrameEnd
        else
          value.ItemDesc

    @applyFilters()

    # keep time frame start/end up to date (TBD)
    $scope.$watch 'c.filters.timeFrame', =>
      if @filters.timeFrame?.ItemCd != 4
        @filters.timeFrameStart = null
        @filters.timeFrameEnd = null

    @savedFilters = []
    @standardFilters = [
      { name: '12 Months', data: { timeFrame: @timeFrameOptions[0], timeFrameEnd: null, contactRole: [], vehicleRelationship: [], unitType: [], applicationCode: [] } }
      { name: '24 Months', data: { timeFrame: @timeFrameOptions[1], timeFrameEnd: null, contactRole: [], vehicleRelationship: [], unitType: [], applicationCode: [] } }
      { name: '36 Months', data: { timeFrame: @timeFrameOptions[2], timeFrameEnd: null, contactRole: [], vehicleRelationship: [], unitType: [], applicationCode: [] } }
    ]
    @sharedFilters = []