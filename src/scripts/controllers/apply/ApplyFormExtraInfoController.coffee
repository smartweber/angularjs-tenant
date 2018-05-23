angular.module('appForm')
.controller('ApplyFormExtraInfoController', [
  '$scope'
  ($scope) ->
    $scope.numTenants = $scope.getFormChildObject('otherTenants').tenants.length
    $scope.user = $scope.getFormChildObject('user', {bio: ''})
])
