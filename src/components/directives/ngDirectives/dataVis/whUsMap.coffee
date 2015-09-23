class whUsMap extends Directive
  constructor: ($q, $log) ->
    link = (scope, element, attrs) =>
      buildTitle = () -> if scope.chartTitle then text: scope.chartTitle, x: -20 else null
      buildSubTitle = () -> if scope.chartSubTitle then text: scope.chartSubTitle, x: -20 else null

      tiles = L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
        maxZoom: 18,
        attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors, Points &copy 2012 LINZ'
      })
      latlng = L.latLng(40, -100)

      map = L.map(element[0], {center: latlng, zoom: 4, layers: [tiles]});
      layers = L.layerGroup([]).addTo(map)

      updateMap = ->
        layers.clearLayers()
        for ix, s of scope.series
          ((ix, s) ->
            series = s
            # probably will need to customize the markers/popups, etc.
            markers = if scope.autoGroup?
                L.markerClusterGroup({
                  iconCreateFunction: (cluster) ->
                    new L.DivIcon({ html: '<b class="marker-cluster" style="height: 40px; width: 40px; background-color: ' + series.color + '">' + cluster.getChildCount() + '</b>', className: 'no-class-needed' })
                })
              else
                L.layerGroup()
            for dix, d of (scope.data || [])[ix] || []
              ((dix, d) ->
                marker = L.marker new L.LatLng(d.lat, d.lng), {
                  icon: new L.DivIcon({ iconSize: [10,10], html: '<div class="marker-cluster" style="background-color: ' + series.color + '; height: 5px; width: 5px;"></div>', className: 'no-class-needed' })
                }
                ###stopEventPropagation = (e) ->
                  console.log 'disabling...'
                  e.preventDefault()
                  e.stopPropagation()
                  return
                marker.on 'mouseover', (e) ->
                  stopEventPropagation e.originalEvent
                marker.on 'mouseout', (e) ->
                  stopEventPropagation e.originalEvent###
                marker.bindPopup scope.tooltipFormatter({ point: { series: { index: ix }, index: dix }  }), { pane: 'popupPane' }
                markers.addLayer marker
              )(dix, d)
            layers.addLayer markers
          )(ix, s)
        console.log layers

      scope.$watch 'series', updateMap, true
      scope.$watch 'data', updateMap

    return {
    link
    restrict: 'A'
    scope:
      data: '=?'
      series: '=?'
      chartTitle: '=?'
      chartSubTitle: '=?'
      tooltipFormatter: '&'
      groupTooltipFormatter: '&'
      onClicked: '&'
      autoGroup: '@'
    }
