class ReflowMemory extends Controller
  constructor: ($scope) ->
    @count = 0
    $scope.$on "reflow", => @count++
