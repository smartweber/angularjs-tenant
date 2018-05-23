# Generates a component with an input element of type text.
# Arguments:
#   value       - [string] Assignable angular expression to data-bind to
#   placeholder - [string] (optional)
#     The placeholder for the input and default text for the view
#   subline     - [string] (optional)
#     Small bit of text to display just below the input
#   name        - [string] (optional)
#     Passed directly to the actual input element
#   required    - [boolean] (optional) Simulates the required attribute
angular.module('pt.nlForm.text', [])
.directive('nlText', [
  '$timeout',
  ($timeout) ->
    return {
      restrict: 'EA'
      replace: true
      scope: {
        placeholder: '@'
        subline: '@'
        name: '@'
        value: '='
      }
      templateUrl: 'directives/nlForm/text.html'
      controller: 'NLTextController'
      link: (scope, element, attributes) ->
        # is this input required?
        scope.required = not angular.isUndefined(attributes.required)

        scope.$watch 'opened', (val) ->
          if val is true
            $timeout (-> element.find('input')[0].focus()), 200
    }
])
.controller 'NLTextController', [
  '$scope'
  ($scope) ->
    # is the input open
    $scope.opened = false

    # has the input been blurred
    $scope.touched = false

    # open the input
    $scope.open = (event) ->
      event.stopPropagation()
      $scope.opened = true

    # close the input
    $scope.close = ->
      $scope.opened = false
      $scope.touched = true

    # Check if return is pressed
    $scope.keyPressed = (event) ->
      $scope.opened = false if event.keyCode is 13

    # if there is no value, show the placeholder instead
    $scope.viewValue = ->
      if not $scope.value or $scope.value is ''
        return $scope.placeholder
      $scope.value

    # do we have a subline? ok, then show it!
    $scope.showSubline = ->
      angular.isString($scope.subline) and $scope.subline isnt ''
]
