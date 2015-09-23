class ColorPalette extends Service
  build: (basePalette, numberOfColors) ->
    # protect against a bad call
    return [] if numberOfColors == 0

    # see if we have a hard-coded config for this
    if basePalette[numberOfColors-1]?
      return basePalette[numberOfColors-1]

    # http://www.cs.rit.edu/~ncs/color/t_convert.html
    rgbToHsv = (rgb) ->
      r = rgb.r / 255.0
      g = rgb.g / 255.0
      b = rgb.b / 255.0

      min = Math.min r, g, b
      max = Math.max r, g, b

      v = max
      delta = max - min;
      if max == 0
        return { h: -1, s: 0, v: 0 }

      s = delta / max
      if delta == 0
        h = 0
      else
        if r == max
          h = ( g - b ) / delta # between yellow & magenta
        else
          if g == max
            h = 2 + ( b - r ) / delta # between cyan & yellow
          else
            h = 4 + ( r - g ) / delta # between magenta & cyan

      h *= 60 # degrees
      h += 360 if h < 0
      return {h: h, s: s, v: v}
    
    hsvToRgb = (hsv) ->
      if( hsv.s == 0 )
        # achromatic (grey)
        return { r: hsv.v * 255, g: hsv.v * 255, b: hsv.v * 255 }

      h = hsv.h / 60; # sector 0 to 5
      i = Math.floor h
      f = h - i # factorial part of h
      p = hsv.v * ( 1 - hsv.s )
      q = hsv.v * ( 1 - hsv.s * f )
      t = hsv.v * ( 1 - hsv.s * ( 1 - f ) )

      switch i
        when 0 then { r: hsv.v * 255, g: t * 255, b: p * 255 }
        when 1 then { r: q * 255, g: hsv.v * 255, b: p * 255 }
        when 2 then { r: p * 255, g: hsv.v * 255, b: t * 255 }
        when 3 then { r: p * 255, g: q * 255, b: hsv.v * 255 }
        when 4 then { r: t * 255, g: p * 255, b: hsv.v * 255 }
        when 5 then { r: hsv.v * 255, g: p * 255, b: q * 255 }
        else null

    parseRGBColor = (html) ->
      parts = html.match(/^#(..?)(..?)(..?)$/)
      return null if parts.length < 4
      rgb =
        r: parseInt parts[1], 16
        g: parseInt parts[2], 16
        b: parseInt parts[3], 16

    buildRGBColor = (rgb) ->
      r = Math.round(rgb.r).toString(16)
      r = "0" + r while r.length < 2
      g = Math.round(rgb.g).toString(16)
      g = "0" + g while g.length < 2
      b = Math.round(rgb.b).toString(16)
      b = "0" + b while b.length < 2
      "#" + r + g + b

    createIntermediates = (start, end, count) ->
      return [] if count == 0

      start = rgbToHsv parseRGBColor start
      end = rgbToHsv parseRGBColor end

      # make sure we take the shortest path
      if Math.abs(start.h-end.h) > 180
        if start.h > end.h
          start.h -= 360
        else
          end.h -= 360

      for i in [1..count]
        point =
          h: (end.h - start.h) / (count+1) * i + start.h
          s: (end.s - start.s) / (count+1) * i + start.s
          v: (end.v - start.v) / (count+1) * i + start.v
        if point.h < 0
          point.h += 360
        buildRGBColor hsvToRgb point

    # nope, we need to generate one
    initial = basePalette[basePalette.length - 1]
    toGenerate = numberOfColors - initial.length
    gaps = initial.length - 1
    gapSize = (Math.floor(toGenerate / gaps) + (if i < toGenerate % gaps then 1 else 0) for i in [0...gaps])

    result = []
    for i in [0...gaps]
      result = result.concat initial[i], createIntermediates initial[i], initial[i+1], gapSize[i]
    result = result.concat initial[initial.length-1]

    result


