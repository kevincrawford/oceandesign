class SideNavRoutes extends Config
	constructor: ($routeProvider) ->
		$routeProvider
		.when '/Branding/SideNav',
			caption: 'Side Navigation'
			controller: 'sideNavController'
			controllerAs: 'controller'
			templateUrl: 'pages/sideNav/sideNav.html'
			label: 'Side Navigation'
			sortLabel: '04 Side Navigation'