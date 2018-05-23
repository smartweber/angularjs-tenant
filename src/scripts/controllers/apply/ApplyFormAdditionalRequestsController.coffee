angular.module('appForm')
.controller('ApplyFormAdditionalRequestsController', [
  '$scope'
  ($scope) ->
    $scope.requestOpts = [
      {value: false, label: 'no'}
      {value: true, label: 'some'}
    ]

    $scope.numTenants = $scope.getFormChildObject('otherTenants').tenants.length
    $scope.user = $scope.getFormChildObject('user', {additional_request: ''})
    $scope.hasRequest = $scope.user.additional_request.length isnt 0
])
