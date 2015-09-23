class RiskColorPalette extends Service
  constructor: (@colorPaletteService) ->
    firstColor = '#679146'
    middleColors = [
      '#FEC057'
      '#EC881D'
      '#A2AD00'
      '#56A0D3'
      '#7C2B83'
      '#85CDDB'
      '#AEAEAE'
      '#002C5F'
    ]
    lastColor = '#F75353'
    @basePalette = [ [ firstColor ] ].concat(
      for n in [0..(middleColors.length)]
        [firstColor].concat(middleColors[i] for i in [0...n]).concat([lastColor])
    )
  build: (numberOfColors) ->
    @colorPaletteService.build @basePalette, numberOfColors
