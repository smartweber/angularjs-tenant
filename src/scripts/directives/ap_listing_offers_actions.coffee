class APListingOffersActions
  constructor: ->
    return {
      controller: 'APListingOffersActionsController'
      replace: true
      restrict: 'AE'
      scope: {
        ngModel: '='
      }
      templateUrl: 'directives/ap-listing-offers-actions.html'
      link: (scope, element, attrs) ->
        scope.ngModel = scope.ngModel
    }



class APListingOffersActionsController
  @$inject: ['$scope', '$state', 'listing']

  constructor: ($scope, $state, listing) ->
    if $scope.ngModel
      $scope.state = listing.offerState($scope.ngModel)
      $scope.property_id = $scope.ngModel.id

    $scope.schedule = (id) ->
      $state.go 'detail', { id: id }
angular
  .module('appForm')
  .directive('apListingOffersActions', APListingOffersActions)
  .controller('APListingOffersActionsController',
    APListingOffersActionsController)
