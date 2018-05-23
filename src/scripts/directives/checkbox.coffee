(->

  class CheckboxDirective
    constructor: ->
      return {
        restrict: 'E'
        templateUrl: 'directives/checkbox.html'
        replace: true
        scope: {
          placeholder: '@'
          ngModel: '='
        }
        link: (scope, element, attrs) ->
          scope.ngModel = scope.ngModel or false

          scope.toggleCheck = ->
            scope.ngModel = not scope.ngModel
      }



  angular
    .module('appForm')
    .directive('checkbox', CheckboxDirective)

)()
