class whRefine extends Directive
  constructor: (@$log) ->
    template = (element, attrs) ->
      values = {}
      types = {}
      for c in element.children()
        x = angular.element(c)
        elements = x.children()
        for e in x.find("*")
          for a in e.attributes
            if a.value.indexOf("$parent") == 0
              a.value = "$parent.$parent.$parent." + a.value
        name = x.attr 'wh-field'
        if name
          for v in name.split('|')
            values[v] = elements
        type = x.attr 'wh-field-type'
        if type
          for v in type.split('|')
            types[v] = elements

      selectedFieldTemplate = angular.element '<div class="wh-refine-item"><div wh-select expand options="item.availableFields" selected="item.selectedField"></div></div>'
      selectedFieldTemplate.append '<div class="wh-refine-delete-field" ng-click="deleteFilter($index)"><span class="glyphicon glyphicon-remove-circle"></span> Remove</div>'
      valueTemplate = angular.element '<div wh-expand expanded="item.expanded" text="\'Value\'"></div>'
      valueTemplateInner = angular.element '<div style="padding: 10px;" ng-switch="item.selectedField.ItemCd"></div>'
      for k,v of values
        sw = angular.element "<div></div>"
        sw.attr "ng-switch-when", k
        sw.append i for i in v
        valueTemplateInner.append sw
      typeTemplateInner = angular.element '<div ng-switch-otherwise ng-switch="item.selectedField.Type"></div>'
      for k,v of types
        sw = angular.element "<div></div>"
        sw.attr "ng-switch-when", k
        sw.append i for i in v
        typeTemplateInner.append sw
      valueTemplateInner.append typeTemplateInner
      valueTemplate.append valueTemplateInner
      selectedFieldTemplate.append valueTemplate

      appliedFiltersTemplate = angular.element '<div class="wh-refine"></div>'
      appliedFilterTemplate = angular.element '<div class="form-group" ng-repeat="item in boundFilters"></div>'
      appliedFilterTemplate.append selectedFieldTemplate
      appliedFiltersTemplate.append appliedFilterTemplate

      appliedFiltersTemplate.append angular.element '<div><button class="btn" ng-click="addField()"><span class="glyphicon glyphicon-plus"></span> Add field</button></div>'

      appliedFiltersTemplate[0].outerHTML

    link = (scope, element, attrs) ->
      scope.refineId = ("refine_" + Math.random()).replace(".","")
      scope.addField = ->
        scope.boundFilters.push {
          selectedField: null
          availableFields: (i for i in scope.fields when !scope.filters.hasOwnProperty i.ItemCd)
          value: null
          expanded: false
        }
      scope.deleteFilter = (fieldIx) ->
        scope.boundFilters.splice fieldIx, 1

      blockNextUpdate = false

      # prevent extra unnecessary updates - keeps us from rebinding the HTML (which collapses controls) more often than necessary
      scope.$watch "[fields, filters]", ->
        if blockNextUpdate
          blockNextUpdate = false
          return

        lastExpanded = {}
        for v in scope.boundFilters || []
          lastExpanded[v.selectedField?.ItemCd] = v.expanded

        boundFilters = for k,v of (scope.filters || {})
          selectedField = (i for i in scope.fields when i.ItemCd == k)[0] || null
          {
            selectedField
            availableFields: (i for i in scope.fields when i.ItemCd == k || !scope.filters.hasOwnProperty i.ItemCd)
            value: v
            expanded: lastExpanded[selectedField?.ItemCd]
          }

        if !angular.equals(scope.boundFilters, boundFilters)
          scope.boundFilters = boundFilters

      , true

      scope.$watch "boundFilters", ->
        # update available fields since we may have changed the value of one of the dropdowns
        usedFields = {}
        for v in (scope.boundFilters || [])
          usedFields[v.selectedField?.ItemCd] = 1
        for v in (scope.boundFilters || [])
          v.availableFields = (i for i in scope.fields when i.ItemCd == v.selectedField?.ItemCd || !usedFields.hasOwnProperty i.ItemCd)

        filters = {}
        for i in (scope.boundFilters || []) when i.selectedField
          filters[i.selectedField.ItemCd] = i.value
        if !angular.equals(scope.filters, filters)
          blockNextUpdate = true
          scope.filters = filters
      , true


    return {
    link
    template
    restrict: 'A'
    scope:
      fields: '='
      filters: '='
    }