class StructurePickerRoutes extends Config
  constructor: ($routeProvider) ->
    $routeProvider.when "/uxTest/structurePicker",
      label: "Structure Picker"
      templateUrl: "pages/uxTest/structurePicker/index.html"
    $routeProvider.when "/uxTest/structurePicker/dashboard",
      label: "Dashboard"
      templateUrl: "pages/uxTest/structurePicker/dashboard.html"
    $routeProvider.when "/uxTest/structurePicker/detail",
      label: "Detail"
      templateUrl: "pages/uxTest/structurePicker/detail.html"
