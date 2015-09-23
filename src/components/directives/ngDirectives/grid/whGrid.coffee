class whGrid extends Directive
  constructor: ($q, $timeout, slickGridInfiniScrollRemoteModelService, $compile, $http, $templateCache, $log, deviceService, $window) ->
    @values = {}
    # default edit templates for various types - we can add more here if we identify some more reusable ones
    # we can't use $templateCache here, so we just inject the content into this file during the build process :)
    dateRangeTemplate = <%= readFileAsString("src/components/directives/ngDirectives/grid/dateRange.html")%>
    numberRangeTemplate = <%= readFileAsString("src/components/directives/ngDirectives/grid/numberRange.html")%>
    textTemplate = <%= readFileAsString("src/components/directives/ngDirectives/grid/text.html")%>

    buildFilterElement = (elements) ->
      newE = $('<div class="wh-grid-filter-full"></div>')
      newE.append $("<div></div>").append(elements)
      newE.append '<div class="wh-grid-filter-buttons clearfix"><button class="btn btn-active pull-left" ng-click="realValue = value; close = true">Apply</button><button class="btn btn-default pull-right" ng-click="close = true">Close</button></div>'
      newE

    @types = {
      dateRange: buildFilterElement angular.element(dateRangeTemplate)
      numberRange: buildFilterElement angular.element(numberRangeTemplate)
      # the text template includes the buttons, so we don't need to wrap it via buildFilterElement
      text: angular.element(textTemplate)
    }

    # scan our child elements for templates before they get replaced with our template
    template = (element, attrs) =>
      for c in element.children()
        x = angular.element(c)
        elements = x.children()
        for e in x.find("*")
          for a in e.attributes
            if a.value.indexOf("$parent") == 0
              a.value = "$parent." + a.value
        name = x.attr 'wh-field'

        isCustom = x.attr('wh-custom')?
        if !isCustom
          elements = buildFilterElement elements

        if name
          for v in name.split('|')
            values[v] = elements
        type = x.attr 'wh-field-type'
        if type
          for v in type.split('|')
            types[v] = elements

      '<div class="wh-grid"></div><div class="wh-grid-footer"><span class="wh-grid-footer-result-count">{{resultCount || 0}} Total Results</span></div>'

    link = (scope, element, attrs) =>
      scope.showMobileVersion = deviceService.current() == "xs"
      scope.$on "CurrentDeviceChanged", ->
        scope.showMobileVersion = deviceService.current() == "xs"

      element.addClass("wh-grid-container")
      isLoading = true
      autoDisplayFirstItem = !!attrs.autoDisplayFirstItem
      multiselect = !!attrs.multiselect
      chkSelector = if multiselect then new Slick.CheckboxSelectColumn() else null
      scope.configuration = scope.configuration || { columns: [], dataSource: () -> $q.when([]) }
      loadData = () ->
        # sort changed
        isLoading = true
        scope.displayed = null
        model.changeSettings scope.configuration, {Field:scope.sort,SortDirection:if scope.sortDir is 'asc' then 1 else 2}
      oldColumns = []
      updateColumns = () ->
        hasDisplayed = !!scope.displayed && !scope.showMobileVersion
        columns = for c in scope.configuration.columns when !(if hasDisplayed then c.hiddenDisplayed else c.hiddenNotDisplayed)
          #https://github.com/mleibman/SlickGrid/wiki/Column-Options
          resizable = if hasDisplayed then c.resizableDisplayed else c.resizable
          sortable = if hasDisplayed then c.sortableDisplayed else c.sortable
          alignClass = if c.align? then (if c.align == "center" then "wh-column-center" else if c.align == "right" then "wh-column-right" else "wh-column-left")
          cssClass = []
          headerCssClass = []
          if c.cssClass? then cssClass.push c.cssClass
          if c.headerCssClass? then headerCssClass.push c.headerCssClass
          if alignClass then cssClass.push alignClass
          if alignClass then headerCssClass.push alignClass
          {
          id: c.index
          field: c.index
          name: c.title
          formatter: (if hasDisplayed then c.formatterDisplayed else null) || c.formatter
          resizable: if resizable? then resizable else true
          sortable: if sortable? then sortable else true
          width: if c.width? then c.width else 100
          cssClass: cssClass.join(" ")
          headerCssClass: headerCssClass.join(" ")
          filterType: c.filterType
          }
        if scope.showMobileVersion
          originalColumns = columns
          columns = [
            {
              id: "mobile"
              name: "Mobile"
              formatter: (row, cell, value, columnDef, dataContext) ->
                result = ''
                for c in originalColumns
                  result += '<div class="form-group">
                      <label>' + (c.name || c.field) + '</label>
                      <p>' + (c.formatter || (r,c,v)-> v)(row, cell, dataContext[c.field], columnDef, dataContext) + '</p>
                    </div>'
                result
              resizable: true
              sortable: false
            }
          ]
        if chkSelector
          columns.unshift chkSelector.getColumnDefinition()
        if popoverTemplatePromise
          columns.push { id: "__popover", name: "", width: 22, maxWidth: 22, sortable: false, formatter: () -> "<span class='uxr-popover-info glyphicon glyphicon-info-sign'></span>" }
        if !angular.equals(columns, oldColumns)
          grid.setColumns columns
      reloadData = () ->
        scope.dataId = Math.random()
      updateAutoHeight = ->
        if scope.autoHeight
          extraSpace = element.height() - element.find(".slick-viewport").height()
          space = extraSpace + scope.resultCount * 25 # get row height from somewhere?
          space += 18; # save room for horizontal scroll
          element.css({ maxHeight: Math.ceil(space) + "px" })
          grid.resizeCanvas()
        else
          element.css({ maxHeight: null })

      #default sort field and direction
      if !scope.sort then scope.sort = ((scope.columns || [])[0] || {}).index
      if !scope.sortDir then scope.sortDir = "asc"

      #if the configuration object changes, apply the initial sort
      scope.$watch 'configuration', () ->
        if scope.configuration && scope.configuration.initialSort
          scope.sort = scope.configuration.initialSort
          scope.sortDir = scope.configuration.initialSortDir || "asc"

      # reload the data if dataSource changes, anything under 'filters' changes, or if our sort/direction change
      scope.$watch 'configuration.dataSource', reloadData
      scope.$watch 'configuration.filters', reloadData, true
      scope.$watchCollection '[sort, sortDir]', reloadData
      # reloadData updates dataId, which then causes loadData to get called.  This way we won't accidentally trigger multiple data loads during the same digest cycle
      scope.$watch 'dataId', loadData

      # watch for *any* column configuration change (which allows the controller to show/hide columns on the fly), or when we change between having something/nothing selected
      scope.$watch '[configuration.columns, showMobileVersion, !!configuration.filters]', ->
        element.removeClass("wh-grid-container-compact")
        element.addClass("wh-grid-container-compact") if scope.showMobileVersion
        hasDisplayed = !!scope.displayed && !scope.showMobileVersion
        newOptions =
          if scope.showMobileVersion
            {
            forceFitColumns: true
            rowHeight: (c for c in scope.configuration.columns when !(if hasDisplayed then c.hiddenDisplayed else c.hiddenNotDisplayed)).length * 60
            }
          else
            {
            forceFitColumns: false
            rowHeight: 41
            }

        grid.setOptions newOptions
        grid.invalidate()
        updateColumns()
      , true
      scope.$watch 'displayed == null', () ->
        updateColumns()

      # push updates to displayed/selected/resultCount
      scope.$watch 'displayed', () ->
        if attrs.displayed
          scope.$eval attrs.displayed + ' = displayed'
        if scope.onDisplayed
          scope.onDisplayed displayed: scope.displayed
      scope.$watch 'selected', () ->
        if attrs.selected
          scope.$eval attrs.selected + ' = selected'
        if scope.onSelected
          scope.onSelected selected: scope.selected
      scope.$watch 'resultCount', () ->
        if attrs.resultCount
          scope.$eval attrs.resultCount + ' = resultCount'
      scope.$watch 'autoHeight', ->  updateAutoHeight()

      options =
        editable: false
        enableAddRow: false
        enableCellNavigation: true
        asyncEditorLoading: false
        enableColumnReorder: false
        enableAsyncPostRender: true
        headerRowHeight: 38

      model = slickGridInfiniScrollRemoteModelService.create()
      grid = new Slick.Grid(element.find(".wh-grid"), model.data, [], options)
      grid.setSelectionModel new Slick.RowSelectionModel( selectActiveRow: !multiselect )

      popoverTemplate = null
      popoverTemplatePromise = null
      updatePopover = () ->
        popoverTemplatePromise =
          if scope.popoverTemplate
            $q.when(scope.popoverTemplate)
          else if scope.popoverTemplateUrl
            $http.get scope.popoverTemplateUrl, cache: $templateCache
          else null
        if popoverTemplatePromise
          popoverTemplatePromise.then (val) -> popoverTemplate = val.data
        updateColumns()
      #scope.$watch '[ popoverTemplate, popoverTemplateUrl ]', updatePopover
      updatePopover() # calls updateColumns()
      loadData()

      # for an unknown reason, the first popup shown doesn't stay wired to the element that caused it to show, so it never gets removed
      popoverRow = null
      grid.onClick.subscribe (e,args) ->
        scope.onClick { event: e, args: args, data: model.data }
        if $(e.target).is(".uxr-popover-info")
          popoverRow = args.row
      element.popover {
        selector: ".uxr-popover-info"
        container: 'body' # .slick-viewport should work, but it just disappears right away. body means it won't move with the scroll
        html: true
        placement: 'left'
        trigger: 'click'
        content: () ->
          return null if !popoverTemplate?
          childScope = scope.$new true
          childScope.$apply () ->
            childScope.item = model.data[popoverRow] # can't figure out a way to derive this from the .slickrow :(
          html = $compile(popoverTemplate)(childScope)
          childScope.$apply () -> {} # need to make sure we run a digest *after* the $compile()() call so that the HTML is initially populated
          html
      } if element.popover

      lastDisplayedRow = null
      grid.onClick.subscribe (e,args) ->
        row = args.row
        grid.resetActiveCell()
        if scope.unDisplayRows && row == lastDisplayedRow
          lastDisplayedRow = null
          row = null
        else
          lastDisplayedRow = row

        # update the displayed item
        $timeout () ->
          scope.$apply () ->
            scope.displayed = if row? then model.data[row] else null

      # register this *after* our click handler is attached so we'll get called when the checkbox is clicked even though it stops propogation
      if chkSelector
        grid.registerPlugin chkSelector

      grid.onSelectedRowsChanged.subscribe (e,args) ->
        #$log.debug e, grid.getSelectedRows()
        selected = grid.getSelectedRows()
        # update the selected item
        $timeout () ->
          scope.$apply () ->
            scope.selected =
              if multiselect
                if selected?
                  for i in selected
                    model.data[i]
                else []
              else
                if selected? && selected.length then model.data[selected[0]] else null

      grid.onViewportChanged.subscribe (e, args) ->
        vp = grid.getViewport()
        model.ensureData vp.top, vp.bottom

      grid.onSort.subscribe (e, args) ->
        scope.$apply () ->
          scope.sort = args.sortCol.field
          scope.sortDir = if args.sortAsc then "asc" else "desc"
        model.clear()
        vp = grid.getViewport()
        model.ensureData vp.top, vp.bottom

      model.onDataLoaded.subscribe (e, args) ->
        grid.invalidateRow i for i in [args.from..args.to]
        grid.updateRowCount()
        grid.render()
        if isLoading && autoDisplayFirstItem && model.data[0]
          $timeout ()->
            # set displayed directly
            scope.$apply () ->
              scope.displayed = model.data[0];
          if !multiselect
            # we're in single-select mode, so displayed == selected, so we need to trigger select too
            grid.setSelectedRows([0])
        isLoading = false
        $timeout ->
          scope.$apply ->
            scope.resultCount = if model.data.getLength? then model.data.getLength() else model.data.length
            updateAutoHeight()

      model.onDataClear.subscribe ->
        grid.setSelectedRows []
        grid.resetActiveCell()
        vp = grid.getViewport()
        model.ensureData vp.top, vp.bottom
        grid.updateRowCount()
        grid.render()

      # wire up watches between filter and child filter scopes
      childScopes = {}
      scope.$watch 'configuration.filters', () ->
        if scope.configuration.filters
          for id,value of scope.configuration.filters
            childScope = childScopes[id]
            if childScope && !angular.equals(childScope.realValue, value)
              childScope.realValue = value
          for id,childScope of childScopes
            if !scope.configuration.filters[id] && childScope.realValue
              childScope.realValue = null
      , true
      scope.$on "destroy", () ->
        v.$destroy() for v in childScopes

      # wire up grid header filters - need to do something with disposing active scopes when we don't need them anymore or something
      grid.onHeaderCellRendered.subscribe (e, args) =>
        # find the element we'll use as our pattern
        colId = args.column.id
        ele = @values[colId] || if args.column.filterType then @types[args.column.filterType] else null
        return if !ele

        childScope = childScopes[colId]
        if !childScope
          childScope = childScopes[colId] = scope.$new()
          childScope.realValue = null
          childScope.$watch 'realValue', () ->
            if scope.configuration.filters
              if childScope.realValue == ""
                childScope.realValue = null
              scope.configuration.filters[colId] = childScope.realValue
            if childScope.realValue?
              if childScope.realValue != ""
                childScope.filter.addClass "wh-grid-filter-applied"
            else
              childScope.filter.removeClass "wh-grid-filter-applied"
          , true
          childScope.$watch 'close', (realValue) ->
            return if !realValue
            hideFilterPopovers()
            # user may have changed some realValues, let's try to clean things up
            if childScope.realValue == ""
              # is an empty string
              childScope.realValue = null
            if childScope.realValue
              if childScope.realValue.length? && childScope.realValue.length == 0
                # is an array, but has zero elements
                childScope.realValue = null
              if (childScope.realValue.rangeLow? || childScope.realValue.rangeHigh?) && !childScope.realValue.rangeLow && !childScope.realValue.rangeHigh
                # is a range, but has no high or low
                childScope.realValue = null

        childScope.realValue = scope.configuration.filters?[colId]

        filter = $('<div class="wh-grid-filter"><i class="fa fa-filter"></i></div>').appendTo args.node
        filter.popover {
          content: () ->
            newEle = ele.clone()
            $compile(newEle)(childScope)
            childScope.$apply () ->
            newEle
          html: true
          placement: 'bottom'
          trigger: 'focus'
          container: 'body'
        }
        .on 'click', (e) ->
          element.find(".wh-grid-filter").not(this).popover("hide")
          childScope.close = null
          childScope.value = childScope.realValue
          $(this).popover 'show'
          e.stopPropagation()

        childScope.filter = filter

      # load the first page
      grid.onViewportChanged.notify()

      onResize = -> grid.resizeCanvas()

      addResizeListener element.find(".wh-grid")[0], onResize

      hideFilterPopovers = (e) ->
        return if e && e.target && ($(e.target).closest(".popover").length > 0 || $(e.target).closest("body").length == 0) # ignore event if it's in a popup, or somehow outside of body
        element.find(".wh-grid-filter").popover("hide")
      $("body").on "click", hideFilterPopovers

      scope.$on '$destroy', ->
        removeResizeListener element.find(".wh-grid")[0], onResize
        $("body").off "click", hideFilterPopovers

    return {
    template
    link
    restrict: 'A'
    replace: false
    scope:
      configuration: '=configuration'
      displayed: '=?displayed'
      onDisplayed: '&'
      unDisplayRows: '=?unDisplayRows'
      selected: '=?selected'
      onSelected: '&'
      popoverTemplate: '='
      popoverTemplateUrl: '='
      onClick: '&'
      resultCount: '=?'
      autoHeight: '=?' # if this is true, you set height via normal styling, and the directive will set max-height to collapse the grid when few rows are present
    }
# configuration is:
# {
#    dataSource: a function that returns a promise
#       argument: { configuration: <config object provided to grid, including any custom stuff you attached>, sort: [ field, direction ], start: 0-based index of the first row to return, limit: number of rows to return }
#       result: { total: # of rows without paging, start: 0-based index of the first row returned, results: [] of data to display }
#    filters: a representation of the filters applied.  Data will automatically reload when anything in this changes
#    initialSort: field to sort by
#    initialSortDir: "asc" or "desc"
#    columns: an array of columns to display, each of which has a number of properties:
#       index: the name of the property that should be displayed in this column
#       title: the text to be displayed in the column header
#       hiddenDisplayed: if true, this column when an item is displayed
#       hiddenNotDisplayed: if true, hide this column when an item is not displayed
#       formatter: the formatter to be used to build the data to show for the column
#       formatterDisplayed: if set, use this instead of formatter when an item is displayed
# }
