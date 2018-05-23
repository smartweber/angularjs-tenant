angular.module('appForm')
.controller('ApplyFormTenantsController', [
  '$scope'
  ($scope) ->
    tenantFactory = -> {
      annual_income: ''
      email: '',
      employment_status: '',
      is_adult: '',
      job: '',
      name: '',
      phone: '',
      smoker: '',
    }

    $scope.numbersOpts = [
      {value: 0, label: 'no'}
      {value: 1, label: '1'}
      {value: 2, label: '2'}
      {value: 3, label: '3'}
      {value: 4, label: '4'}
    ]
    $scope.otherTenants = $scope.getFormChildObject('otherTenants', {
      tenants: []
    })
    $scope.numTenants = $scope.otherTenants.tenants.length

    $scope.$watch 'numTenants', (newValue, oldValue) ->
      if(newValue > oldValue)
        while($scope.otherTenants.tenants.length < newValue)
          $scope.otherTenants.tenants.push(tenantFactory())
      else if(newValue < oldValue)
        $scope.otherTenants.tenants = $scope.otherTenants.tenants[0...newValue]

    $scope.onFormValid = ->
      $scope.nextSection() if $scope.currentSectionIdx <= 3
])
