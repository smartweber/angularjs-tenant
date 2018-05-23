angular.module('appForm')
.controller('ApplyFormPaymentAndLeaseController', [
  '$scope', '$filter',
  ($scope, $filter) ->
    $scope.monthsOpts = [
      {value: '1', label: 'one'}
      {value: '2', label: 'two'}
      {value: '3', label: 'three'}
      {value: '4', label: 'four'}
      {value: '5', label: 'five'}
      {value: '6', label: 'six'}
    ]
    $scope.dpOptions = {
      minDate: new Date(),
      showWeeks: false
      maxMode: 'day'
    }

    $scope.numTenants = $scope.getFormChildObject('otherTenants').tenants.length
    $scope.payment = $scope.getFormChildObject('payment', {
      monthly_rent: null
      advance_rent_months: null
      lease_starts_on: new Date
    })

    $scope.onFormValid = ->
      return if $scope.formPart7.$pristine
      $scope.nextSection() if $scope.currentSectionIdx <= 4
])
