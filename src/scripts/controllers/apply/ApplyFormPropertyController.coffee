angular.module('appForm')
.controller('ApplyFormPropertyController', [
  '$scope', '$location', 'currentAgent',
  ($scope, $location, currentAgent) ->
    # Lookup the listing ID on the server for current Agent details
    lookupListing = (listingId) ->
      listings = [
        {
          id: '1'
          address: 'listing 1 address'
          agent: {
            name: 'Agent 1'
            stylesheet: 'body{background:red;}div{padding:10px;}'
          }
        },
        {
          id: '2'
          address: 'listing 2 address'
          agent: {
            name: 'Agent 2'
            stylesheet: 'body{background:blue;}div{padding:20px;}'
          }
        }
      ]

      for listing in listings
        if listing.id is listingId
          $scope.property.listing_id = listing.id
          $scope.property.address = listing.address
          currentAgent.loadCustomizations(listing.agent)

    $scope.property = $scope.getFormChildObject('property', {
      listing_id: ''
      address: ''
      letting_agent: ''
      branch_location: ''
    })

    searchObj = $location.search()
    lookupListing(searchObj.listing_id) if searchObj.listing_id

    $scope.onFormValid = ->
      return if $scope.formPart4.$pristine
      $scope.nextSection() if $scope.currentSectionIdx <= 1
])
