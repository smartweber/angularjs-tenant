class APListingOffersInfo
  constructor: ->
    return {
      controller: 'APListingOffersInfoController'
      replace: true
      restrict: 'AE'
      scope: {
        ngModel: '='
      }
      templateUrl: 'directives/ap-listing-offers-info.html'
      link: (scope, element, attrs) ->
        scope.ngModel = scope.ngModel
    }



class APListingOffersInfoController
  @$inject: ['$scope', 'listing']

  constructor: ($scope, listing) ->
    if $scope.ngModel
      $scope.state = listing.offerState($scope.ngModel)

    $scope.isHighestOffer = ->
      $scope.ngModel?.my_application?.monthly_rent >=
      $scope.ngModel?.applications?.highest_offer

    $scope.percDiffToHighestOffer = ->
      this_offer    = $scope.ngModel?.my_application?.monthly_rent
      highest_offer = $scope.ngModel?.applications?.highest_offer
      if this_offer <= highest_offer
        ratio = this_offer / highest_offer
        diff  = 100 - (ratio * 100)
        _.round(diff, 1)

    $scope.newApplicationOffer = ->
      false #TODO



angular
  .module('appForm')
  .directive('apListingOffersInfo', APListingOffersInfo)
  .controller('APListingOffersInfoController', APListingOffersInfoController)
