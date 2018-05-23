# A generic component that serves mostly as a wrapper for arbitrary contents.
# Arguments:
#   placeholder - [string] Angular expression with the text to display
angular.module('pt.nlForm.field', [])
.directive('nlField', ->
  return {
    controller: 'NLFieldController'
    replace: true
    restrict: 'EA'
    scope: {
      placeholder: '<'
    }
    templateUrl: 'directives/nlForm/field.html'
    transclude: true
    link: (scope, element, attributes) ->
      return
  }
).controller 'NLFieldController', [
  '$scope'
  ($scope) ->
    # is the input open
    $scope.opened = false

    # open the input
    $scope.open = (event) ->
      event.stopPropagation()
      $scope.opened = true

    # close the input
    $scope.close = ->
      $scope.opened = false

    # Show the placeholder
    $scope.viewValue = -> $scope.placeholder
]
