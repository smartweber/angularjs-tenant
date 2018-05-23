class PropertyDetailController
  @$inject: ['$scope', '$state', '$stateParams', 'api']

  constructor: ($scope, $state, $stateParams, api) ->

    $scope.fetchData = (property_id) ->
      $scope.loading_status = 'pending'
      url = "/tenant/listings/#{property_id}/viewing/"
      console.log url

      api.get(url)
        .success (response, status, headers) ->
          console.log response
        .error (response) ->
          $scope.loading_status = 'failed'

    $scope.fetchData $stateParams.id


angular
  .module('appForm')
  .controller('PropertyDetailController', PropertyDetailController)
