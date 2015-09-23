class App extends App
  constructor: ->
    return [
      'ngAnimate'
      'ngRoute'
      # coffeelint: disable=coffeescript_error
      <% if (useBackendless) { %>
      'ngMockE2E'
      <% } %>
      # coffeelint: enable=coffeescript_error
      'angular-loading-bar'
      'restangular'
      'ng-breadcrumbs'
      'ui.ace'
      'ngSanitize'
      'angularFileUpload'
    ]
