class StructurePicker extends Service
  constructor: ($window, @$rootScope, @$compile, @$q) ->
    body = $(window.document.body)
    @content = body.find("#content")
    @overlayContent = body.find("#overlayContent")
    @savedFilters = []
    @currentFilter = []
  getCurrent: -> @currentFilter
  loadSavedFilters: ->
    d = @$q.defer()
    setTimeout =>
      d.resolve @savedFilters
    , 500
    d.promise
  save: (name, selected) ->
    d = @$q.defer()
    setTimeout =>
      @savedFilters.push
        Name: name
        Selected: selected
      d.resolve()
    , 500
    d.promise
  show: ->
    scope = @$rootScope.$new()
    element = @$compile('<div ng-include="\'pages/uxTest/structurePicker/popup.html\'"></div>')(scope)
    @overlayContent.hide()
    @overlayContent.empty()
    @overlayContent.append element
    @overlayContent.show 'fade'
    null
  hide: ->
    @overlayContent.hide 'fade'
    null
  toggle: ->
    if @overlayContent.is ":visible"
      @hide()
    else
      @show()
  apply: (newFilter) ->
    @currentFilter = newFilter
    d = @$q.defer()
    setTimeout (() -> d.resolve()), 500
    d.promise