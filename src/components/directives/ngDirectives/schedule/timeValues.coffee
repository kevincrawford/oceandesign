class TimeValues extends Service
  constructor: () ->
  getTimeValues: ->
    values = []
    pad = (value) ->
      value = "" + value
      value = "0" + value while value.length < 2
      value
    for h in [0..23]
      for m in [0,30]
        mPad = pad m
        hour = h % 12
        hour = if hour % 12 == 0 then "12" else hour

        values.push {
          ItemDesc: hour + ":" + mPad + (if h < 12 then " AM" else " PM")
          ItemCd: "" + pad(h) + mPad
        }
    values

  getDaysOfWeek: ->
    [
      { ItemCd: 0, ItemDesc: 'Sunday' }
      { ItemCd: 1, ItemDesc: 'Monday' }
      { ItemCd: 2, ItemDesc: 'Tuesday' }
      { ItemCd: 3, ItemDesc: 'Wednesday' }
      { ItemCd: 4, ItemDesc: 'Thursday' }
      { ItemCd: 5, ItemDesc: 'Friday' }
      { ItemCd: 6, ItemDesc: 'Saturday' }
    ]
  getWeeksOfMonth: ->
    [
      { ItemCd: 1, ItemDesc: 'First' }
      { ItemCd: 2, ItemDesc: 'Second' }
      { ItemCd: 3, ItemDesc: 'Third' }
      { ItemCd: 4, ItemDesc: 'Fourth' }
      { ItemCd: 5, ItemDesc: 'Fifth' }
    ]
  getMonths: ->
    [
      { ItemCd: 1, ItemDesc: 'January' }
      { ItemCd: 2, ItemDesc: 'February' }
      { ItemCd: 3, ItemDesc: 'March' }
      { ItemCd: 4, ItemDesc: 'April' }
      { ItemCd: 5, ItemDesc: 'May' }
      { ItemCd: 6, ItemDesc: 'June' }
      { ItemCd: 7, ItemDesc: 'July' }
      { ItemCd: 8, ItemDesc: 'August' }
      { ItemCd: 9, ItemDesc: 'September' }
      { ItemCd: 10, ItemDesc: 'October' }
      { ItemCd: 11, ItemDesc: 'November' }
      { ItemCd: 12, ItemDesc: 'December' }
    ]
