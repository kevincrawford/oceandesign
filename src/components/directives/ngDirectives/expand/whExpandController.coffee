class whExpand extends Controller
  constructor: (@$scope) ->
    @$scope.expanded = false
    @$scope.toggle = => @.toggle()
  toggle: ->
    @$scope.expanded = !@$scope.expanded

