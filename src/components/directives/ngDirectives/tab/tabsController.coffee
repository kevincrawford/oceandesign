class Tabs extends Controller
  constructor: ($scope, $log, $element, $timeout) ->

    $scope.panes = []

    $scope.select = (pane) ->
#      $log.debug 'select: collapsible=' + $scope.collapsible + ', autoCollapse=' + $scope.autoCollapse
      newSelected = !pane.selected
      for p in $scope.panes
        p.selected = false

      if $scope.collapsible
        pane.selected = newSelected
      else
        pane.selected = true
      # broadcast down from the scope after the pane (the transcluded body of the pane) to tell controls their size may have changed.
      $timeout -> $scope.$apply -> pane.$$nextSibling?.$broadcast "reflow"

    @select = $scope.select

    @addPane = (pane) ->
#      $log.debug 'addpane: collapsible=' + $scope.collapsible + ', autoCollapse=' + $scope.autoCollapse
      if (!$scope.panes.length)
        $scope.select(pane)

      if $scope.autoCollapse
        pane.selected = false

      pane.collapsiblePane = $scope.collapsible
      $scope.panes.push(pane)

    $scope.setCollapsible = () ->
#      $log.debug 'setCollapsible: collapsible=' + $scope.collapsible + ', autoCollapse=' + $scope.autoCollapse
      for p in $scope.panes
        p.collapsible = $scope.collapsible
        if $scope.autoCollapse
          p.selected = false
