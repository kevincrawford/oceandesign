
class AppConfig extends Config
  constructor: (@RestangularProvider) ->
    # determine the base URL for our requests based on the browser's URL
    baseUrl =
      if window && window.location
        loc = window.location
        path = loc.pathname
        # find the last slash and trim everything after it
        lastIndex = path.lastIndexOf('/')
        if path.length-1 != lastIndex && lastIndex != -1
          path = path.substring(0, lastIndex + 1)
        loc.protocol + "//" + loc.host + path
      else "http://localhost:8181"
    @RestangularProvider.setBaseUrl baseUrl
    @RestangularProvider.setDefaultHeaders {'Content-Type':'application/json;'}
    @RestangularProvider.setDefaultRequestParams {'format':'json'}




