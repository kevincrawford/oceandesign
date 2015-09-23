examples = <%= JSON.stringify(examples) %>
class HeadingsRoutes extends Config
	endsWith = (str, suffix) -> str.indexOf(suffix, str.length - suffix.length) != -1
	labelFilter = /^[0-9. ]*/

	constructor: ($routeProvider) ->
		all = {}
		all[e]= e for e in examples
		for e in examples
			if endsWith(e, "index.html")
				prefix = e.replace("/index.html","")
				url = prefix.replace("pages/examples","")
				fragments = url.split('/')
				thisExamples =
					for i in examples when i.indexOf(prefix) == 0 && endsWith(i, ".html") && !endsWith(i, "index.html") && prefix.split('/').length+1 == i.split('/').length
						base = i.replace(".html","")
						baseParts = base.split('/')
						{
							title: baseParts[baseParts.length - 1].replace labelFilter, ""
							html: i
							coffee: all[base + ".coffee"]
							css: all[base + ".css"]
							js: all[base + ".js"]
							extraFilesFile: all[base + "-extra.json"]
						}
				tagsFile = all[e.replace(".html", ".txt")]
				url = fragments.map((i) -> i.replace labelFilter,"").join("/")
				$routeProvider
					.when url,
						caption: fragments[fragments.length-1].replace labelFilter, ""
						label: fragments[fragments.length-1].replace labelFilter, ""
						sortLabel: fragments[fragments.length-1]
						controller: 'dynamicController'
						controllerAs: 'controller'
						examples: thisExamples
						indexContent: e
						templateUrl: "pages/dynamic.html"
						tagsFile: tagsFile