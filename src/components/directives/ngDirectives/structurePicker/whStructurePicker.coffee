class whStructurePicker extends Directive
  constructor: ($window) ->
    link = (scope, element, attrs, ngModel) =>
      clearCachedCalls = ->
        for i in data
          i.areAllVisibleDescendentsChecked = null
          i.isAnyVisibleDescendentChecked = null
      isAnyVisibleDescendentChecked = (item) ->
        if !item.isAnyVisibleDescendentChecked?
          item.isAnyVisibleDescendentChecked = (->
            for i in item.children when i.visible
              if i.checked || isAnyVisibleDescendentChecked i
                return true
            return false)()
        return item.isAnyVisibleDescendentChecked
      isAncestorChecked = (item) ->
        return false if !item.parent
        item.parent.checked || isAncestorChecked item.parent
      areAllVisibleDescendentsChecked = (item) ->
        if !item.areAllVisibleDescendentsChecked?
          item.areAllVisibleDescendentsChecked = (->
            return true if item.checked
            visibleChildren = (i for i in (item.children || []) when i.visible)
            if visibleChildren.length
              for i in visibleChildren
                return false if !areAllVisibleDescendentsChecked i
              return true
            else
              return false
          )()
        return item.areAllVisibleDescendentsChecked
      checkAllNonVisibleDescendents = (item) ->
        for i in (item.children || [])
          if i.visible
            checkAllNonVisibleDescendents i
          else
            i.checked = true
            # by not going further down, we avoid having to call simplfyChecks (which would just collapse back to this)
      checkAllVisibleDescendents = (item) ->
        if (item.children || []).length
          for i in item.children when i.visible
            if i.children.length == 0
              i.checked = true
            checkAllVisibleDescendents i
        else
          item.checked = true
      uncheckAllVisibleDescendents = (item) ->
        for i in (item.children || []) when i.visible
          i.checked = false
          uncheckAllVisibleDescendents i
      # since checking an item is the equivalent of checking all it's children, see if we can move the checked flag up the tree anywhere
      simplifyChecks = (item) ->
        if(item.children || []).length > 0
          simplifyChecks i for i in item.children
          # if any of the children aren't checked, we can't merge anything for this item
          return for i in item.children when !i.checked
          # all children were checked - merge away
          i.checked = false for i in item.children
          item.checked = true
      checkItem = (item) ->
        # if no filters were applied, we could just check ourselves, clear our descendents, and be done, but it doesn't work like that :(
        # so, we check everything that's visible, then simplify
        checkAllVisibleDescendents item
        simplifyChecks(item.parent || item)
        updateItemAndRelated item
      uncheckItem = (item) ->
        if item.checked
          # uncheck this item
          item.checked = false
          uncheckDescendents item
          checkAllNonVisibleDescendents item
          updateItemAndRelated item
        else
          # since we weren't checked directly, one of our ancestors must have been, or else all of our visible children were
          if isAncestorChecked item
            # walk up the tree to the checked item, unchecking parent and checking siblings
            parent = item.parent
            while parent
              for i in parent.children when i != item
                i.checked = true
              if parent.checked
                # ok, this was the one that was checked - clear it and we're done
                parent.checked = false
                break
              item = parent
              parent = item.parent
            # ok, now here's where it gets fun.... if any of our descendents aren't visibile, this 'exclude' doesn't apply to them, so we have to check them.
            checkAllNonVisibleDescendents item
          uncheckAllVisibleDescendents item
          updateItemAndRelated parent || item
      uncheckDescendents = (item) ->
        for i in item.children
          i.checked = false
          uncheckDescendents i
      updateItemAndRelated = (item) ->
        clearCachedCalls()
        updateItemAndChildren item
        parent = item.parent
        while parent
          dataView.updateItem parent.id, parent
          parent = parent.parent
      updateItemAndChildren = (item) ->
        dataView.updateItem item.id, item
        updateItemAndChildren i for i in item.children
      updateSelected = () ->
        scope.$apply () ->
          scope.selected = getSelected()
      getSelected = () ->
        # add any new items to the beginning of the list, leaving any still-selected items in their original order
        checked = {}
        for i in data when i.checked
          checked[i.id] = i
        newSelected = []
        for i in scope.selected || []
          if checked[i.id]
            newSelected.push checked[i.id]
            delete checked[i.id]
        for k, i of checked
          newSelected.unshift i
        newSelected

      data = []
      formatter = (row, cell, value, columnDef, dataContext) ->
        if dataContext.RelativeClientAccountNumber
          value = dataContext.RelativeClientAccountNumber + " " + (value || "")
        value = (value || "").replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;")
        spacer = "<span style='display:inline-block;height:1px;width:" + (15 * (dataContext.indent - 1)) + "px'></span>"
        checkbox =
          if dataContext.checked || isAncestorChecked(dataContext) || areAllVisibleDescendentsChecked(dataContext)
            "<input type=\"checkbox\" checked=\"\" class=\"hidden\" /><i class=\"fa fa-check-square\"></i>"
          else if isAnyVisibleDescendentChecked dataContext
            "<input type=\"checkbox\" data-indeterminate=\"true\" class=\"hidden\"/><i class=\"fa fa-minus-square-o\"></i>"
          else
            "<input type=\"checkbox\" class=\"hidden\" /><i class=\"fa fa-square-o\"></i>"
        if (i for i in dataContext.children when i.visible).length
          if (dataContext.collapsed)
            spacer + "<i class=\"fa fa-angle-right wh-structure-toggle\"></i>" + checkbox + "&nbsp;" + value
          else
            spacer + "<i class=\"fa fa-angle-down wh-structure-toggle\"></i>" + checkbox + "&nbsp;" + value
        else
          spacer + "<i class=\"fa fa-angle-right wh-structure-toggle invisible\"></i>" + checkbox + "&nbsp;" + value
      postRender = (cellNode, row, dataContext, colDef) ->
        if $(cellNode).find(":checkbox").data("indeterminate")
          $(cellNode).find(":checkbox")[0].indeterminate = true

      keyedById = {}
      keyedByParentId = {}

      columns = [
        id: "Name", name: "Name", field: "Name", width: 220, cssClass: "cell-title", formatter: formatter, asyncPostRender: postRender
      ]

      options =
        editable: false
        enableAddRow: false
        enableCellNavigation: false
        asyncEditorLoading: false
        enableColumnReorder: false
        enableAsyncPostRender: true
        forceFitColumns: true
        rowHeight: 42

      filter = (item) ->
        if !item.visible
          return false
        parent = item.parent
        while parent
          if parent.collapsed
            return false
          parent = parent.parent
        return true

      showChildren = (item) ->
        for i in item.children || []
          i.visible = true
          showChildren i

      lastAppliedFilter = ""
      updateFilter = (filter)->
        if !data
          return

        clearCachedCalls()
        lastAppliedFilter = filter
        i.collapsed = true for i in data when (i.children || []).length
        if filter
          filter = filter.toLowerCase()
          # items matching the filter:
          # 1. show themselves, their ancestors, and their descendents
          # 2. expand their ancestors
          i.visible = false for i in data
          for i in data when (i.Name || "").toLowerCase().indexOf(filter) >= 0
            i.visible = true
            p = i.parent
            while p && !p.visible
              p.visible = true
              p.collapsed = false
              p = p.parent
            showChildren i
        else
          # no filter == everything visible
          i.visible = true for i in data

      orderByName = (list) ->
        x = [].concat(list)
        x.sort (a,b) -> if a.Name > b.Name then 1 else if a.Name < b.Name then -1 else 0
        x

      setup = () ->
        data = []
        keyedById = {}
        keyedByParentId = {}
        items = for i in scope.data || []
          item = angular.copy(i)
          item.id = item.Id
          (item.RelativeClientAccountNumber = x) for x in (item.ClientAccountNumber || "").split(':') # get the last segment of the ClientAccountNumber
          keyedById[item.Id] = item
          keyedByParentId[item.ParentId] = (keyedByParentId[item.ParentId] || [])
          keyedByParentId[item.ParentId].push item
          item
        for i in items when i.Active || scope.showInactive
          i.parent = keyedById[i.ParentId]
          i.children = keyedByParentId[i.Id] || []
          if i.children.length
            i.collapsed = true
        load = (item) ->
          item.indent = ((item.parent || {}).indent || 0) + 1
          data.push item
          load i for i in orderByName item.children
        if scope.skipRoot
          for i in keyedByParentId[0] || []
            for j in orderByName i.children
              j.parent = null
              load j
        else
          load i for i in keyedByParentId[0] || []
        updateFilter scope.filter
        dataView.beginUpdate()
        dataView.setItems data
        dataView.endUpdate()

      dataView = new Slick.Data.DataView({ inlineFilters: true })
      dataView.beginUpdate()
      dataView.setItems []
      dataView.setFilter filter
      dataView.endUpdate()

      element.addClass "wh-structure-picker"
      grid = new Slick.Grid(element, dataView, columns, options)

      grid.onCellChange.subscribe (e, args) ->
        dataView.updateItem args.item.id, args.item

      grid.onClick.subscribe (e, args) ->
        tgt = $(e.target)
        if tgt.hasClass("wh-structure-toggle")
          item = dataView.getItem args.row
          if item
            item.collapsed = !item.collapsed
            dataView.updateItem item.id, item
          e.stopImmediatePropagation()
        else # checkbox or row can be clicked to toggle the row
          item = dataView.getItem args.row
          if item
            if item.checked || isAncestorChecked(item) || areAllVisibleDescendentsChecked(item)
              uncheckItem item
              updateSelected()
            else
              checkItem item
              updateSelected()
          e.stopImmediatePropagation()

      dataView.onRowCountChanged.subscribe () ->
        grid.updateRowCount()
        grid.render()
      dataView.onRowsChanged.subscribe (e, args) ->
        grid.invalidateRows args.rows
        grid.render()

      scope.$watchCollection "[data, skipRoot, showInactive]", setup

      scope.$watchCollection "[filter, minFilterLength]", ->
        realFilter = (scope.filter || "").toLowerCase()
        # short filters are the same as no filter
        if realFilter.length < (if scope.minFilterLength? then scope.minFilterLength else 3)
          realFilter = ""

        # apply the filter if it's different
        if lastAppliedFilter != realFilter
          updateFilter realFilter
          dataView.refresh()
          grid.invalidateRows ([0..(dataView.getLength()-1)])
          grid.render()

      scope.$watch 'selectAll', ->
        if scope.selectAll
          # act like the checkbox was clicked for each (visible) top-level item
          for i in data when !i.parent && i.visible
            checkAllVisibleDescendents i
            simplifyChecks i
          clearCachedCalls()
          scope.selected = getSelected()
          grid.invalidateRows ([0..(dataView.getLength()-1)])
          grid.render()
        scope.selectAll = null

      scope.$watch 'deselectAll', ->
        if scope.deselectAll
          # act like the checkbox was cleared for each (visible) top-level item
          for i in data when !i.parent && i.visible
            if i.checked
              # uncheck this item
              i.checked = false
              uncheckDescendents i
              checkAllNonVisibleDescendents i
            else
              uncheckAllVisibleDescendents i
          clearCachedCalls()
          scope.selected = getSelected()
          grid.invalidateRows ([0..(dataView.getLength()-1)])
          grid.render()
        scope.deselectAll = null

      scope.$watch 'collapseAll', ->
        if scope.collapseAll
          i.collapsed = true for i in data when i.children.length
          dataView.refresh()
          grid.invalidateRows ([0..(dataView.getLength()-1)])
          grid.render()
        scope.collapseAll = null

      scope.$watch 'expandAll', ->
        if scope.expandAll
          i.collapsed = false for i in data when i.children.length
          dataView.refresh()
          grid.invalidateRows ([0..(dataView.getLength()-1)])
          grid.render()
        scope.expandAll = null

      scope.$watch 'selected', (v) ->
        now = {}
        for i in v
          now[i.id] = true

        for i in data when i.checked && !now[i.id]
          uncheckItem i
        for i in v when !keyedById[i.id].checked
          checkItem keyedById[i.id]

        newSelected = getSelected()
        if !angular.equals newSelected, scope.selected
          scope.selected = newSelected

      scope.$on "reflow", -> grid.resizeCanvas()
      $($window).on "resize", -> grid.resizeCanvas()


    return {
      link
      replace: true
      restrict: 'A'
      scope:
        data: '=?'
        skipRoot: '=?' # if true, skips the top-level items (ie. the client)
        showInactive: '=?'
        filter: '=?'
        minFilterLength: '=?'
        selected: '=?'
        selectAll: '=?'
        deselectAll: '=?'
        expandAll: '=?'
        collapseAll: '=?'
    }