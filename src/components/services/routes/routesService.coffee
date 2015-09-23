class Routes extends Service
	constructor: ($route) ->
    @getChildren = (path) =>
      path = path + "/" if path.substring(path.length-1) != "/"
      matches = []
      parts = path.split('/').length
      for k, v of $route.routes
        continue if not k?
        continue if k is 'null'
        continue if k is ''
        continue if k is path
        continue if k is path + "/"
        continue if k.lastIndexOf(path, 0) != 0
        continue if k.substring(k.length-1) == '/'
        continue if k.split('/').length != parts

        matches.push sortLabel: v.sortLabel, label: v.label, href: k, hideFromNav: v.hideFromNav
      matches.sort (a,b) ->
        a = a.sortLabel || a.label
        b = b.sortLabel || b.label
        if a < b then -1 else if a == b then 0 else 1
      matches