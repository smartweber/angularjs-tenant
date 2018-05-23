angular.module('appForm')
.controller('AppyFormSmokerController', [
  '$scope'
  ($scope) ->
    $scope.smokerOpts = [
      {value: true, label: 'am'}
      {value: false, label: 'am not'}
    ]

    $scope.lead_applicant = $scope.getFormChildObject('lead_applicant', {
      smoker: false
    })
])
