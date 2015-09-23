class OtherChartsPalette extends Controller
  constructor: (dataVisColorPaletteService) ->
    colors = dataVisColorPaletteService.getColors()
    @palettes = for n in [1..(colors.length)]
      colors[i] for i in [0...n]