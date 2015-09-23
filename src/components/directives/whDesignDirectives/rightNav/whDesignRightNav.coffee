class WhDesignRightnav extends Directive
	constructor: (routesService, $location, $rootScope) ->
		link = (scope, element, attrs) =>
			setItems = () ->
				p = $location.path()
				parts = p.split('/')
				if parts.length > 1 && parts[1]
					base = "/" + parts[1]
					build = (href) ->
						items =
							for item in routesService.getChildren(href) when !item.hideFromNav
								{
									label: item.label
									href: item.href
									activeSelf: item.href == p
									activeParent: p.substring(0, item.href.length) == item.href
									items: build item.href
								}
						items
					scope.display = true
					scope.items = build base
				else
					scope.display = false
					scope.items = []
			setItems()
			$rootScope.$on "$locationChangeSuccess", setItems

		return {
			link
			replace: true
			restrict: 'A'
			templateUrl: 'components/directives/whDesignDirectives/rightNav/whDesignRightNav.html'
			scope: {}
		}