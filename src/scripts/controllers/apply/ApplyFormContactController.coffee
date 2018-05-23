angular.module('appForm')
.controller('ApplyFormContactController', [
  '$scope'
  ($scope) ->
    $scope.user = $scope.getFormChildObject('user', {
      name: ''
      email: ''
      phone: ''
    })

    $scope.onFormValid = ->
      return if $scope.formPart1.$pristine
      $scope.nextSection() if $scope.currentSectionIdx <= 1
])
