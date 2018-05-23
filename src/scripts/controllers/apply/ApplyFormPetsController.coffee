angular.module('appForm')
.controller('ApplyFormPetsController', [
  '$scope'
  ($scope) ->
    $scope.petsOpts = [
      {value: false, label: 'will not'}
      {value: true, label: 'will'}
    ]

    $scope.numTenants = $scope.getFormChildObject('otherTenants').tenants.length
    $scope.user = $scope.getFormChildObject('user', {has_pets: false})
])
