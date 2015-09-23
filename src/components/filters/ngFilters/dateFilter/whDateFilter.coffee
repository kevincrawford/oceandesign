class whDateFilter extends Filter
  constructor: ($filter)->
    ###
    # filter takes two two parameters, 1) input date 2) format (optional)
    # if no format is specified, by default the format will be 'MM/dd/yyyy'
    # eg: $filter('dateFilter')('2014-01-01T20:00:03.0005000', 'MM/dd')
    ###
    return (inputDt, format) ->
      if format is null or format is undefined
        format = 'MM/dd/yyyy'
      if inputDt is '0001-01-01T00:00:00.0000000' or inputDt is null
        return ''
      else
        $filter('date')(inputDt,format)

