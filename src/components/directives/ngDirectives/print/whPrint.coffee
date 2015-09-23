class whPrint extends Directive
  constructor:  ($log) ->
    link = (scope, element, attr) =>
      scope.detectUA = (ua, appName, appVersion) =>
        tem             = undefined

        M = ua.match(/(opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)/i) or []
        if /trident/i.test(M[1])
          tem = /\brv[ :]+(\d+)/g.exec(ua) or []
          return "IE " + (tem[1] or "")
        if M[1] is "Chrome"
          tem = ua.match(/\bOPR\/(\d+)/)
          return "Opera " + tem[1]  if tem?
        M = (if M[2] then [ M[1], M[2] ] else [ appName, appVersion, "-?" ])
        M.splice 1, 1, tem[1]  if (tem = ua.match(/version\/(\d+)/i))?
        M.join " "

      scope.printPreview = () =>

        detectedUA = scope.detectUA(navigator.userAgent, navigator.appName, navigator.appVersion)
        window.print() if !detectedUA.startsWith('Opera')

    return {
      link
      restrict: 'A'
      templateUrl: 'components/directives/ngDirectives/print/whPrint.html'
    }
