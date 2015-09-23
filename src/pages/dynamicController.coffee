class Dynamic extends Controller
	constructor: (routesService,$route,$location) ->
		p = $location.path()
		route = v for k,v of $route.routes when k == p
		@examples = route.examples
		@indexContent = route.indexContent
		@children = routesService.getChildren(p)