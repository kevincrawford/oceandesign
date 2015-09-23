class whFilterList extends Directive
  constructor: ->
    link = (scope,element,attrs) =>
    return {
    link
    restrict: 'AE'
    templateUrl : 'components/directives/whDirectives/filterList/whFilterList.html'
    scope:
      items: '='
      canDelete: '=?'
      text: '=?'
      html: '=?'
      itemApply: '&'
      itemDelete: '&'
      itemSchedule: '&'
    }
