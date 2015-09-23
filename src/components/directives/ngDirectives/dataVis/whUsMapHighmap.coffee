class whUsMapHighmap extends Directive
  constructor: ($q, $log) ->
    link = (scope, element, attrs) =>
      autoGroup = attrs.autoGroup?

      buildTitle = () -> if scope.chartTitle then text: scope.chartTitle, x: -20 else null
      buildSubTitle = () -> if scope.chartSubTitle then text: scope.chartSubTitle, x: -20 else null

      dataScript = $q.defer()
      $.getScript "//code.highcharts.com/mapdata/countries/us/us-all.js", -> dataScript.resolve()

      scripts = $q.when(dataScript.promise)

      # https://github.com/deremer/Cities/ - city, ll
      scripts.then ->
        configMain = Highcharts.maps["countries/us/us-all"]['hc-transform'].default
        configMain.proj = proj4("WGS84",configMain.crs)
        # AK/HI is too much to mess with for the moment - wait until Highmaps actually supports it
        #configAK = Highcharts.maps["countries/us/us-all"]['hc-transform']['us-all-alaska']
        #configHI = Highcharts.maps["countries/us/us-all"]['hc-transform']['us-all-hawaii']
        #configAK.proj = proj4("WGS84",configAK.crs)
        #configHI.proj = proj4("WGS84",configHI.crs)
        #config = if c.city.indexOf(", AK, ") >= 0 then configAK else if c.city.indexOf(", HI, ") >= 0 then configHI else configMain

        distSquared = (p1, p2) ->
          Math.pow(Math.abs(p1.lat-p2.lat),2) + Math.pow(Math.abs(p1.lng-p2.lng),2)
        isNear = (p1, p2, nearFactor) ->
          distSquared(p1, p2) <= Math.pow(nearFactor, 2)

        fillBuckets = (data, buckets) ->
          for ix, d of data
            bb = buckets[0]
            bbcost = distSquared(d, bb)
            for b in buckets
              cost = distSquared(d, b)
              if cost < bbcost
                bb = b
                bbcost = cost
            bb.points.push d
            bb.pointsIx.push ix

        buildBuckets = (data, nearFactor) ->
          buckets = []
          if !data.length
            return buckets
          # take a stab in the dark to create some buckets and put things in them
          for d in data
            bucket = b for b in buckets when isNear d, b, nearFactor
            if !bucket
              buckets.push { lat: d.lat, lng: d.lng, points: [], pointsIx: [] }
          fillBuckets data, buckets
          if buckets.length == data.length
            return buckets

          # now, find the centroid of each, update the coordinates, and empty it
          for b in buckets
            b.lat = (b.points.reduce ((a,v) -> a + v.lat), 0) / b.points.length
            b.lng = (b.points.reduce ((a,v) -> a + v.lng), 0) / b.points.length
            b.points = []
            b.pointsIx = []

          # and fill them back up
          fillBuckets data, buckets

          # delete any buckets that have no items
          buckets.filter (b) -> !!b.points.length

        updateZoom = (evt) ->
          for i, ix in chart.series
            if ix >= 2
              i.setData buildData(ix-2), true

        dataBuckets = {};

        buildData = (ix) ->
          d = (scope.data || [])[ix] || []
          buckets = null
          if autoGroup && !scope?.series?[ix]?.disableAutoGroup
            filteredData = [].concat(d)
            if chart && chart.xAxis[0] && chart.xAxis[0].max?
              config = configMain
              # find extent points
              x = chart.xAxis[0]
              y = chart.yAxis[0]
              points = [
                [x.min, y.max]
                [x.min, (y.min + y.max) / 2]
                [x.min, y.min]
                [(x.min + x.max) / 2, y.max]
                [(x.min + x.max) / 2, (y.min + y.max) / 2]
                [(x.min + x.max) / 2, y.min]
                [x.max, y.max]
                [x.max, (y.min + y.max) / 2]
                [x.max, y.min]
              ]
              # now that we have coords, reverse-project to lng/lat
              points = for p in points
                config.proj.inverse [
                  (p[0] + config.jsonmarginX * 9/2) / config.scale / config.jsonres
                  -(p[1] + config.jsonmarginY * 2/3) / config.scale / config.jsonres
                ]
              xMin = points.reduce ((a, p) -> if p[0] < a then p[0] else a), 1000
              xMax = points.reduce ((a, p) -> if p[0] > a then p[0] else a), -1000
              yMin = points.reduce ((a, p) -> if p[1] < a then p[1] else a), 1000
              yMax = points.reduce ((a, p) -> if p[1] > a then p[1] else a), -1000

              # ....and now use that to figure out the separation factor we want to use
              nearFactor = Math.min(Math.abs(xMin-xMax),Math.abs(yMin-yMax)) / 50
              filteredData = filteredData.filter (p) -> xMin - nearFactor <= p.lng && p.lng <= xMax + nearFactor && yMin - nearFactor <= p.lat && p.lat <= yMax + nearFactor
            else
              nearFactor = 1.5

            console.log nearFactor, filteredData.length, d.length

            buckets = buildBuckets filteredData, nearFactor
            if buckets.length == d.length
              buckets = null
            dataBuckets[ix] = buckets

          for d in buckets || d
            config = configMain
            p = config.proj.forward [ d.lng, d.lat]
            # complete fix is when highcharts adds *real* lat/long support
            x = (p[0]*config.scale * config.jsonres - config.jsonmarginX * 9/2)
            y = (-p[1]*config.scale * config.jsonres - config.jsonmarginY * 2/3)
            { x:x, y:y, z:d.pointsIx?.length || 1 }

        buildSeries = ->
          pointSeries = for ix, s of scope.series || []
            type = if autoGroup && !s.disableAutoGroup then 'mapbubble' else 'mappoint'
            $.extend {
              type: type
              data: buildData ix
            }, s
          [{
            data : Highcharts.geojson(Highcharts.maps['countries/us/us-all'], 'map'),
            color: 'transparent',
            name: 'Random data',
          },{
            name: 'Separators',
            type: 'mapline',
            data: Highcharts.geojson(Highcharts.maps['countries/us/us-all'], 'mapline'),
            color: 'silver',
            showInLegend: false,
            enableMouseTracking: false
          }].concat pointSeries


        element.addClass("wh-map-chart")
        chart = element.highcharts('Map',
          title: buildTitle()
          subtitle: buildSubTitle()
          chart: style: fontFamily: '"ProximaNovaRgRegular", Arial, sans-serif'
          tooltip:
            formatter: () ->
              seriesIx = this.point.series.index - 2
              if seriesIx < 0
                return scope.tooltipFormatter(this) || false
              if autoGroup && !scope?.series?[seriesIx]?.disableAutoGroup && dataBuckets[seriesIx]
                bucket = dataBuckets[seriesIx][this.point.index]
                obj = $.extend {}, this
                obj.group = bucket

                # grouping mode
                return scope.groupTooltipFormatter(obj) || scope.tooltipFormatter(this) || false
              # not grouping
              return scope.tooltipFormatter(this) || false
            style: padding: 10
          plotOptions:
            series: events: click: (e) ->
              scope.onClicked point: e.point
            mapbubble:
              minSize: 8
              maxSize: 40
            mappoint:
              marker:
                lineWidth: 1
                radius: 4
                symbol: 'circle'
          legend: false
          series: buildSeries()
          credits: false
          mapNavigation:
            enabled: true,
            buttonOptions: verticalAlign: 'bottom'
          colorAxis: min: 0
          xAxis: events: afterSetExtremes: (evt) -> updateZoom evt
        )
        chart = element.highcharts()

        scope.$watch 'series', (() ->
          newSeries = buildSeries()
          if chart.series.length == newSeries.length
            for ix, i of [].concat(chart.series)
              i.update newSeries[ix], false
          else
            for i in [].concat(chart.series)
              i.remove false
            for i in buildSeries()
              chart.addSeries i, false
          chart.redraw()
        ), true

        scope.$watch 'data', (() ->
          for i, ix in chart.series
            if ix >= 2
              i.setData buildData(ix-2), true
        ), true

        scope.$watchCollection '[chartTitle, chartSubTitle]', () -> chart.setTitle buildTitle(), buildSubTitle()
        scope.$on 'reflow', () -> chart.reflow()

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
