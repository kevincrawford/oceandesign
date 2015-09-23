class FilterDescription extends Service
  constructor: ->
  describeOne: (v) ->
    isArray = Array.isArray || ( value ) -> return {}.toString.call( value ) is '[object Array]'
    if isArray v
      "[" + ((this.describeOne i for i in v).join ', ') + "]"
    else
      if v?.ItemDesc
        v.ItemDesc
      else if v?.rangeLow || v?.rangeHigh
        if v.rangeLow && v.rangeHigh
          v.rangeLow + " to " + v.rangeHigh
        else if v.rangeLow
          v.rangeLow + " and up"
        else
          "up to " + v.rangeHigh
      else
        v
  # filters: object hash - key == fields[].ItemCd, value == value
  # fields: the list of fields being displayed - key will lookup by ItemCd and use ItemDesc as the text
  # config: if the item key is present, the supplied method will be called instead of the default rendering.  Return null to not show the field
  getDescription: (filters, fields, config) ->
    parts = []
    fieldsByCd = {}
    for v in fields || []
      fieldsByCd[v.ItemCd] = v.ItemDesc
    results =
      for k,v of filters || {}
        cfg = (config || {})[k] || this.describeOne
        res = cfg.apply this, [v, filters]
        if res?
          fld = fieldsByCd[k] || k
          fld + ": " + res
        else
          null
    (i for i in results when i?).join(', ')
