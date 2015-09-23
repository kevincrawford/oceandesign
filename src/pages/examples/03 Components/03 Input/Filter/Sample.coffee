class FilterSample extends Controller
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
    #0-new,1-queued,3-completed,4-rejected
    @mvrStatusOptions = [
      { ItemCd: 0, ItemDesc: "New"}
      { ItemCd: 1, ItemDesc: "Queued"}
      { ItemCd: 3, ItemDesc: "Completed"}
      { ItemCd: 4, ItemDesc: "Rejected"}
    ]
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
    @defaultRefinements = {}
    @refinementFields = [
      { ItemCd: 'DriverFullName', ItemDesc: 'Name', Type: 'text' }
      { ItemCd: 'ConcatenatedUniqueId', ItemDesc: 'Unique ID', Type: 'text' }
      { ItemCd: 'LastMVRDate', ItemDesc: 'Last MVR Run Date', Type: 'dateRange' }
      { ItemCd: 'LicenseStatus', ItemDesc: 'License Status', Type: 'text' }
      { ItemCd: 'OneYrPoints', ItemDesc: '1YR Point Total', Type: 'numberRange' }
      { ItemCd: 'TwoYrPoints', ItemDesc: '2YR Point Total', Type: 'numberRange' }
      { ItemCd: 'ThreeYrPoints', ItemDesc: '3YR Point Total', Type: 'numberRange' }
      { ItemCd: 'MVRRequestStatus', ItemDesc: 'Current Request Status' }
      { ItemCd: 'MVRReviewed', ItemDesc: 'MVR Reviewed', Type: 'checkbox' }
      { ItemCd: 'MVRReviewedDate', ItemDesc: 'Date/Time Reviewed', Type: 'dateRange' }
      { ItemCd: 'ReviewerName', ItemDesc: 'Reviewer Name', Type: 'text' }
      { ItemCd: 'FleetId', ItemDesc: 'Fleet ID', Type: 'text' }
      { ItemCd: 'StructureID', ItemDesc: 'Division', Type: 'text' }
      { ItemCd: 'VehicleNumber', ItemDesc: 'Vehicle Number', Type: 'text' }
      { ItemCd: 'VehicleStatusDesc', ItemDesc: 'Vehicle Status', Type: 'text' }
      { ItemCd: 'DriversLicenseNumber', ItemDesc: 'License Number', Type: 'text' }
      { ItemCd: 'DriversLicenseState', ItemDesc: 'License State', Type: 'text' }
      { ItemCd: 'BirthDate', ItemDesc: 'Date Of Birth', Type: 'text' }
      { ItemCd: 'ReportId', ItemDesc: 'ReportId', Type: 'text' }
      { ItemCd: 'UniqueId', ItemDesc: 'UniqueId', Type: 'text' }
      { ItemCd: 'RequestId', ItemDesc: 'RequestId', Type: 'text' }
    ]

    @filters = angular.copy @defaultFilters
    @refinements = angular.copy @defaultRefinements

    @applyFiltersAndRefinements = =>
      @appliedFilters = $.extend {}, angular.copy(@filters), angular.copy(@refinements)
      # remove null/undefined filters
      delete @appliedFilters[k] for k in (k for k,v of @appliedFilters when !v?)
      # update the description
      @appliedFiltersDescription = @filterDescriptionService.getDescription(@appliedFilters, @filtersFields, @filtersDescriptionConfig)
    @clearFiltersAndRefinements = =>
      @filters = angular.copy @defaultFilters
      @refinements = angular.copy @defaultRefinements
      @applyFiltersAndRefinements()

    # used to build descriptions of the fields with the filter description service
    @filtersFields = [
      { ItemCd: 'timeFrame', ItemDesc: 'Time Frame'}
      { ItemCd: 'contactRole', ItemDesc: 'Contact Role' }
      { ItemCd: 'vehicleRelationship', ItemDesc: 'Vehicle Relationship' }
      { ItemCd: 'unitType', ItemDesc: 'Unit Type' }
      { ItemCd: 'applicationCode', ItemDesc: 'Application Code'}
    ].concat(@refinementFields)

    # used to override building the descriptions of the fields with the filter description service
    @filtersDescriptionConfig =
      timeFrameStart: -> null
      timeFrameEnd: -> null
      timeFrame: (value, filters) ->
        if value.ItemCd == 4
          value.ItemDesc + ": " + filters.timeFrameStart + " to " + filters.timeFrameEnd
        else
          value.ItemDesc

    @applyFiltersAndRefinements()

    # keep time frame start/end up to date (TBD)
    $scope.$watch 'c.filters.timeFrame', =>
      if @filters.timeFrame?.ItemCd != 4
        @filters.timeFrameStart = null
        @filters.timeFrameEnd = null




