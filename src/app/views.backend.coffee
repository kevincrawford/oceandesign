class ViewsBackend extends Run
	constructor: ($httpBackend) ->
		$httpBackend.whenGET(/^.*$/).passThrough()
		$httpBackend.whenPOST(/^.*$/).passThrough()