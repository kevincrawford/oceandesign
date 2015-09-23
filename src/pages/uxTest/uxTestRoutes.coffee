class StructurePickerRoutes extends Config
  constructor: ($routeProvider) ->
    $routeProvider.when "/uxTest",
      caption: "UX Test"
      label: "UX Test"
      sortLabel: "UX Test"
      templateUrl: "pages/uxTest/index.html"
