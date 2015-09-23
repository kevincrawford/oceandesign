class whSelect extends Directive
  constructor: (@$log) ->
    link = (scope, element, attrs) ->
      isMultiSelect = attrs.multiple?

      scope.idPrefix = "ms_" + (Math.random()+"").replace(".","")
      # scope.allOptions is what we bind to our UI - it's a selected flag plus the item from scope.options
      updateAllOptions = () ->
        sel = if isMultiSelect then scope.selected || [] else if scope.selected then [scope.selected] else []
        scope.allOptions = for i in (scope.options || [])
          { selected: !!(true for ii in sel when ii.ItemCd == i.ItemCd).length, item: i }
        if isMultiSelect
          scope.allSelected = if !sel.length then false else if (scope.options || []).length == sel.length then true else null
        selectedDescriptionsArray = (for i in (scope.selected || [])
          i.ItemDesc)
        selectedDescriptionsArray.sort (a,b) -> if a < b then -1 else if a > b then 1 else 0
        scope.selectedDescriptions = selectedDescriptionsArray.join(', ')

      # scope.selected is the items from scope.options that have the checkbox set
      updateSelected = () ->
        scope.selected = for i in (scope.allOptions || []) when i.selected
            i.item
        if !isMultiSelect
          scope.selected = if scope.selected.length then scope.selected[0] else null

        if attrs.selected
          try
            scope.$eval attrs.selected + ' = selected'
        scope.onSelected scope.selected

      # don't close when clicking on things in the dropdown if this is multi-select
      if isMultiSelect
        element.find "ul.dropdown-menu"
        .on "click", (e) ->
          if(angular.element(e.target).hasClass("wh-multiselect-dropdown-done"))
            return; # allow click on the 'done' button to be handled normally
          e.stopPropagation()

      # update on changes
      scope.$watch "[ options, selected ]", updateAllOptions, true
      scope.$watch "allOptions", updateSelected, true

      if isMultiSelect
        scope.$watch "allSelected", (newV, oldV) ->
          # only update selected if we're being set to true/false.  If we're being set to null, we don't set anything.  This is designed to mesh with the value set in updateAllOptions
          if(newV == true)
            scope.selected = angular.copy(scope.options)
          if(newV == false)
            scope.selected = []

        scope.unselectAll = () ->
          scope.selected = if isMultiSelect then [] else null

    return {
    link
    replace: true
    restrict: 'A'
    templateUrl: (element, attrs) ->
      isMultiSelect = attrs.multiple?
      isDropDown = attrs.dropdown?
      isExpand = attrs.expand?
      if isMultiSelect
        if isExpand
          'components/directives/ngDirectives/select/whMultiSelectExpand.html'
        else if isDropDown
          'components/directives/ngDirectives/select/whMultiSelectDropdown.html'
        else
          'components/directives/ngDirectives/select/whMultiSelect.html'
      else
        if isExpand
          'components/directives/ngDirectives/select/whSingleSelectExpand.html'
        else if isDropDown
          'components/directives/ngDirectives/select/whSingleSelectDropdown.html'
        else
          'components/directives/ngDirectives/select/whSingleSelect.html'
    scope:
      selected: '=?'
      onSelected: '&'
      options: '='
    }