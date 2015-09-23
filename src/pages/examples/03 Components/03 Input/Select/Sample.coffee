class SelectSample extends Controller
  constructor: () ->
    @typeOptions = [ { ItemCd:1, ItemDesc: 'Car' }, { ItemCd: 2, ItemDesc: 'Driver or some long thing to wrap' }, { ItemCd: 3, ItemDesc: 'Building' } ]
    @stateOptions = [ { ItemCd:'IL', ItemDesc: 'Illinois' }, { ItemCd: 'MI', ItemDesc: 'Michigan' }, { ItemCd: 'WI', ItemDesc: 'Wisconsin' }, { ItemCd: 'IN', ItemDesc: 'Indiana'}, { ItemCd: 'IO', ItemDesc: 'Iowa'}, { ItemCd: 'FL', ItemDesc: 'Florida'}, { ItemCd: 'NY', ItemDesc: 'New York'}, { ItemCd: 'NJ', ItemDesc: 'New Jersey'}, { ItemCd: 'VT', ItemDesc: 'Vermont'} ]
    sortOptions = (a,b) -> if a.ItemDesc < b.ItemDesc then -1 else if a.ItemDesc > b.ItemDesc then 1 else 0
    @typeOptions.sort sortOptions
    @stateOptions.sort sortOptions
    @defaultFilters =
      singleState: { ItemCd: 'MI', ItemDesc: 'Michigan' }
      state: [ { ItemCd: 'MI', ItemDesc: 'Michigan' } ]
    @filters = angular.copy @defaultFilters
    @appliedFilters = angular.copy @defaultFilters
    @applyFilters = () =>
      @appliedFilters = angular.copy @filters
    @clearFilters = () =>
      @filters = angular.copy @defaultFilters
      @appliedFilters = angular.copy @defaultFilters
