class SideNav extends Controller
	constructor: ($rootScope, $location) ->
		# this is quite a bit of a hack - guessing there's a better way to do this
		endsWith = (str, suffix) -> str.indexOf(suffix, str.length - suffix.length) != -1
		p = $location.path()
		$("body").removeClass("sidenav-minified")
		$rootScope.$on "$locationChangeSuccess", (e, newUrl, oldUrl) ->
			if endsWith oldUrl, "#" + p
				$("body").addClass("sidenav-minified")
