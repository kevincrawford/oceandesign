class MapDemo extends Controller
  constructor: (@$log, $scope) ->
    @chartTitle = "Title"
    @chartSubTitle = "sub"
    cities = [
      {'city': 'New York, NY', 'll': '40.7143528,-74.00597309999999'}
      ,{'city': 'Los Angeles, CA', 'll': '34.0522342,-118.2436849'}
      ,{'city': 'Chicago, IL', 'll': '41.8781136,-87.6297982'}
      ,{'city': 'Houston, TX', 'll': '29.7601927,-95.36938959999999'}
      ,{'city': 'Philadelphia, PA', 'll': '39.952335,-75.16378900000001'}
      ,{'city': 'Phoenix, AZ', 'll': '33.4483771,-112.0740373'}
      ,{'city': 'San Antonio, TX', 'll': '29.4241219,-98.49362819999999'}
      ,{'city': 'San Diego, CA', 'll': '32.7153292,-117.1572551'}
      ,{'city': 'Dallas, TX', 'll': '32.802955,-96.769923'}
      ,{'city': 'San Jose, CA', 'll': '37.3393857,-121.8949555'}
      ,{'city': 'Jacksonville, FL', 'll': '30.3321838,-81.65565099999999'}
      ,{'city': 'Indianapolis, IN', 'll': '39.7685155,-86.1580736'}
      ,{'city': 'San Francisco, CA', 'll': '37.7749295,-122.4194155'}
      ,{'city': 'Austin, TX', 'll': '30.267153,-97.7430608'}
      ,{'city': 'Columbus, OH', 'll': '39.9611755,-82.99879419999999'}
      ,{'city': 'Fort Worth, TX', 'll': '32.725409,-97.3208496'}
      ,{'city': 'Charlotte, NC', 'll': '35.2270869,-80.8431267'}
      ,{'city': 'Detroit, MI', 'll': '42.331427,-83.0457538'}
      ,{'city': 'El Paso, TX', 'll': '31.7587198,-106.4869314'}
      ,{'city': 'Memphis, TN', 'll': '35.1495343,-90.0489801'}
      ,{'city': 'Baltimore, MD', 'll': '39.2903848,-76.6121893'}
      ,{'city': 'Boston, MA', 'll': '42.3584308,-71.0597732'}
      ,{'city': 'Seattle, WA', 'll': '47.6062095,-122.3320708'}
      ,{'city': 'Washington, DC', 'll': '38.8951118,-77.0363658'}
      ,{'city': 'Nashville, TN', 'll': '36.1658899,-86.7844432'}
      ,{'city': 'Denver, CO', 'll': '39.7391536,-104.9847034'}
      ,{'city': 'Louisville, KY', 'll': '38.2526647,-85.7584557'}
      ,{'city': 'Milwaukee, WI', 'll': '43.0389025,-87.9064736'}
      ,{'city': 'Portland, OR', 'll': '45.5234515,-122.6762071'}
      ,{'city': 'Las Vegas, NV', 'll': '36.114646,-115.172816'}
      ,{'city': 'Las Vegas, NV', 'll': '36.1398498,-115.188916'}
      ,{'city': 'Oklahoma City, OK', 'll': '35.4675602,-97.5164276'}
      ,{'city': 'Oklahoma City, OK', 'll': '35.5006256,-97.6114217'}
      ,{'city': 'Albuquerque, NM', 'll': '35.0844909,-106.6511367'}
      ,{'city': 'Tucson, AZ', 'll': '32.2217429,-110.926479'}
      ,{'city': 'Fresno, CA', 'll': '36.7477272,-119.7723661'}
      ,{'city': 'Fresno, CA', 'll': '36.9858984,-119.2320784'}
      ,{'city': 'Sacramento, CA', 'll': '38.5815719,-121.4943996'}
      ,{'city': 'Long Beach, CA', 'll': '33.8041667,-118.1580556'}
      ,{'city': 'Kansas City, MO', 'll': '39.0997265,-94.5785667'}
      ,{'city': 'Mesa, AZ', 'll': '33.4151843,-111.8314724'}
      ,{'city': 'Virginia Beach, VA', 'll': '36.8529263,-75.97798499999999'}
      ,{'city': 'Atlanta, GA', 'll': '33.7489954,-84.3879824'}
      ,{'city': 'Colorado Springs, CO', 'll': '38.8338816,-104.8213634'}
      ,{'city': 'Omaha, NE', 'll': '41.2523634,-95.99798829999999'}
      ,{'city': 'Raleigh, NC', 'll': '35.772096,-78.6386145'}
      ,{'city': 'Miami, FL', 'll': '25.7889689,-80.2264393'}
      ,{'city': 'Cleveland, OH', 'll': '41.4994954,-81.6954088'}
      ,{'city': 'Tulsa, OK', 'll': '36.1539816,-95.99277500000001'}
      ,{'city': 'Tulsa', 'll': '36.2740199,-96.2375947'}
      ,{'city': 'Oakland, CA', 'll': '37.8043637,-122.2711137'}
      ,{'city': 'Minneapolis, MN', 'll': '44.9799654,-93.26383609999999'}
      ,{'city': 'Wichita, KS', 'll': '37.6922222,-97.3372222'}
      ,{'city': 'Arlington, TX', 'll': '32.735687,-97.10806559999999'}
      ,{'city': 'Bakersfield, CA', 'll': '35.3732921,-119.0187125'}
      ,{'city': 'New Orleans, LA', 'll': '29.95106579999999,-90.0715323'}
      # current approach doesn't work well for HI/AK because of where they are on the map.  Will update this later once HighMaps supports lat/long and we don't have to do the translation ourselves
#      ,{'city': 'Honolulu, HI', 'll': '21.3069444,-157.8583333'}
#      ,{'city': 'Honolulu, HI', 'll': '21.451996,-158.0954459'}
#      ,{'city': 'Anchorage, AK', 'll': '61.2180556,-149.9002778'}
    ]
    cityNames = for c in cities
        p = c.ll.split ','
        { name: c.city, lat: parseFloat(p[0]), lng: parseFloat(p[1]) }
    @data = for l in [1..5]
      for x in [1..40]
        city = cityNames[Math.floor(Math.random() * cityNames.length)]
        { lat: city.lat + (Math.random() * 3 - 1.5), lng: city.lng + (Math.random() * 3 - 1.5), driverName: "Joe Smith", driverAddress: "123 State St., " + city.name }
    @data = [cityNames].concat @data

    @series = [
      { name: "Cities", color: 'black', marker: { lineColor: 'black', fillColor: 'white', lineWidth: 2 }, disableAutoGroup: true }
      { name: "Excellent Driver", subTitle: "0 - 1 points", color: "#2D9D39"}
      { name: "Good Driver", subTitle: "2 - 7 points", color: "#33EA38" }
      { name: "Warning Driver", subTitle: "8 - 12 points", color: "#F6E332" }
      { name: "Elevated Driver", subTitle: "13 - 29 points", color: "#F28B22" }
      { name: "High Risk Driver", subTitle: "30+ points", color: "#B23947" }
    ]
  buildTooltip: (point)=>
    seriesIx = point.series.index - 2
    if seriesIx < 0
      return null
    seriesItem = @series[seriesIx]
    dataItem = @data[seriesIx][point.index]
    if seriesIx == 0
      return dataItem.name
    "<b>" + seriesItem.name + "</b><br/>" + dataItem.driverName + "<br/>" + dataItem.driverAddress + "<br/>"
  buildGroupTooltip: (point, group) =>
    seriesIx = point.series.index - 2
    if seriesIx < 0
      return null
    seriesItem = @series[seriesIx]
    v = "<b>" + group.pointsIx.length + " " + seriesItem.name  + (if group.pointsIx.length > 1 then "s" else "") + "</b>"
    for ix in group.pointsIx
      dataItem = @data[seriesIx][ix]
      v += "<br/>" + dataItem.driverName
    v

