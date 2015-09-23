class WhDesignExample extends Directive
  constructor: ($http, $templateCache, $compile, $timeout) ->
    link = (scope, element, attrs) ->
      scope.showSource = false
      scope.showTheSource = () -> 
        scope.showSource = true
        $timeout () ->
          element
          .find ".nav-tabs a"
          .click (e) ->
            e.preventDefault()
            $(this).tab('show')

      scope.id = Math.random().toString(16).replace(".","")
      scope.makeReadonly = (e) -> e.setReadOnly true
      container = element.find(".html-container");
      if scope.htmlFile?
        scope.html = "<i>loading...</i>";
        $http
        .get scope.htmlFile, cache: $templateCache
        .success (d,s,h,c) -> scope.html = d
      if scope.cssFile?
        scope.css = "/* Loading... */";
        $http
        .get scope.cssFile, cache: $templateCache
        .success (d,s,h,c) -> scope.css = d
      if scope.coffeeFile?
        scope.coffee = "\#Loading...";
        $http
        .get scope.coffeeFile, cache: $templateCache
        .success (d,s,h,c) -> scope.coffee = d
      if scope.jsFile?
        scope.js = "//Loading...";
        $http
        .get scope.jsFile, cache: $templateCache
        .success (d,s,h,c) -> scope.js = d
      if scope.extraFilesFile?
        $http
        .get scope.extraFilesFile, cache: $templateCache
        .success (d,s,h,c) ->
          scope.extraFiles = for k,v of d
            p = v.split "."
            extraFile = { title: k, content: "", mode: p[p.length - 1], key: k.replace(/[^A-Za-z0-9]/,"") }
            do () ->
              ef = extraFile
              $http
              .get v, cache: $templateCache
              .success (d,s,h,c) ->
                ef.content = d
            extraFile

      scope.$watch 'html', (v) ->
        container.html(scope.html)
        $compile(container.contents())(scope)

    return {
      link
      replace: true
      restrict: 'A'
      templateUrl: 'components/directives/whDesignDirectives/example/whDesignExample.html'
      scope:
        htmlFile: '=html'
        cssFile: '=css'
        coffeeFile: '=coffee'
        jsFile: '=js'
        title: '=exampleTitle'
        extraFilesFile: '=extraFilesFile'
    }