class RiskPalette extends Controller
  constructor: (riskColorPaletteService) ->
    @palettes = (riskColorPaletteService.build i for i in [1..30])