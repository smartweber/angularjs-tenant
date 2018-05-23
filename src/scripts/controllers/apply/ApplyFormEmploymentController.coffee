angular.module('appForm')
.controller('ApplyFormEmploymentController', [
  '$scope'
  ($scope) ->
    $scope.employmentOpts = [
      {value: 'unemployed', label: 'unemployed'}
      {value: 'employed', label: 'employed'}
      {value: 'studying', label: 'studying'}
    ]

    $scope.employment_status = ''
    $scope.job = ''

    $scope.lead_applicant = $scope.getFormChildObject('lead_applicant', {
      employment_details: ''
    })

    $scope.$watchGroup ['employment_status', 'job'], (newValue, oldValue) ->
      if newValue isnt oldValue
        $scope.lead_applicant.employment_details =
          "#{$scope.employment_status} #{$scope.job}"
])
