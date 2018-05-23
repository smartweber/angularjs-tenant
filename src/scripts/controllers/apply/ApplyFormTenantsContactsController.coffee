angular.module('appForm')
.controller('ApplyFormTenantsContactsController', [
  '$scope'
  ($scope) ->
    $scope.adulthoodOpts = [
      {value: false, label: 'under 18'}
      {value: true, label: 'over 18'}
    ]
    $scope.smokerOpts = [
      {value: true, label: 'a smoker'}
      {value: false, label: 'not a smoker'}
    ]
    $scope.employmentOpts = [
      {value: 'unemployed', label: 'unemployed'}
      {value: 'employed', label: 'employed'}
      {value: 'studying', label: 'studying'}
    ]

    $scope.otherTenants = $scope.getFormChildObject('otherTenants')

    $scope.onFormValid = ->
      return if $scope.formPart6.$pristine
      $scope.nextSection() if $scope.currentSectionIdx <= 2
])
