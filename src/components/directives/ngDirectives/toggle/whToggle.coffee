class whToggle extends Directive
  # inspired by https://github.com/JumpLink/angular-toggle-switch
  constructor: ($compile) ->
    link = (scope, element, attrs) ->
      scope.toggle = () ->
        if !scope.disabled
          scope.model = !scope.model
        scope.onChange()

      bindSpan = (span) ->
        span = angular.element(span);
        bindAttributeName = 'ng-bind'

        # remove old ng-bind attributes
        span.removeAttr('ng-bind-html');
        span.removeAttr('ng-bind');

        if angular.element(span).hasClass("wh-toggle-text-left")
          span.attr bindAttributeName, 'onText'
        if span.hasClass("wh-toggle-text-right")
          span.attr bindAttributeName, 'offText'

        $compile(span) scope, (cloned, scope) -> span.replaceWith cloned

      # add ng-bind attribute to each span element.
      # NOTE: you need angular-sanitize to use ng-bind-html
      bindSwitch = (iElement) ->
        for span in iElement.find("span")
          bindSpan span

      bindSwitch element

    return {
    link
    replace: true
    restrict: 'A'
    templateUrl: 'components/directives/ngDirectives/toggle/whToggle.html'
    scope:
      model: '='
      disabled: '@',
      onText: '@',
      offText: '@',
      onChange: '&'
    }