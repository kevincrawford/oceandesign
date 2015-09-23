class DonutHelper extends Service
  constructor: (@$log) -> {}
  setChartTitle: (chart, title, subTitle) ->
    pie = chart.series[0]
    return if !pie || !pie.center
    dLeft = chart.plotLeft + pie.center[0];
    dTop = chart.plotTop + pie.center[1];
    cLeft = chart.plotLeft + chart.plotWidth / 2;
    cTop = chart.plotTop + chart.plotHeight / 2;

    left = dLeft - cLeft;
    titleTop = dTop - cTop;

    # correct for bad position at small sizes
    if chart.plotHeight < 120
      titleTop -= (120 - chart.plotHeight) / 120 * 12

    size = Math.min(chart.plotWidth, chart.plotHeight)

    # a bit of magic to get the font-size and top offset to get it to center well
    titleFontSize = size / 7
    titleTop -= Math.round(titleFontSize * 1 / 2); # 2/3 of text height

    subTitle =
      if subTitle
        subTitleFontSize = titleFontSize / 3
        subTitleTop = titleTop + titleFontSize - subTitleFontSize
        titleTop -= subTitleFontSize / 3
        titleFontSize *= 6/7
        if size < 280
          subTitleTop -= (280 - size) / 280 * 6

        text: '<span style="position: relative; left: ' + Math.round(left) + 'px; top: ' + Math.round(subTitleTop) + 'px; font-size: ' + Math.round(subTitleFontSize) + 'px;">' + subTitle + '</span>',
        useHTML: true
        floating: true
        align: 'center'
        verticalAlign: 'middle'

    chart.setTitle
      text: '<span style="position: relative; left: ' + Math.round(left) + 'px; top: ' + Math.round(titleTop) + 'px; font-size: ' + Math.round(titleFontSize) + 'px;">' + (title || "") + '</span>',
      useHTML: true
      floating: true
      align: 'center'
      verticalAlign: 'middle'
    , subTitle
  getDataLabelFormat: (chart) ->
    bigFontSize = Math.floor(Math.min(chart.plotWidth, chart.plotHeight) / 20) + "px"
    littleFontSize = Math.floor(Math.min(chart.plotWidth, chart.plotHeight) / 40) + "px"
    '<div style="border-bottom: 1px solid black; position: relative; top: -43px;"><h1 style="font-size: ' + bigFontSize + '">{point.y}</h1><p style="color: green; font-size: ' + littleFontSize + '">{point.name}</p></div>'
  setDataLabelFormat: (chart) ->
    format = @getDataLabelFormat chart
    for s in chart.series
      if s?.options?.dataLabels?.format != format
        s.update dataLabels: format: format
