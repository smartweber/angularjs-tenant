class DashboardController
  @$inject: ['$scope', 'api', '$timeout']

  constructor: ($scope, api, $timeout) ->

    $scope.current_page = 0
    $scope.per_page     = 15
    $scope.total_count  = 0

    $scope.fallbackUrl = '/images/listing-placeholder.svg'
    $scope.listings = []
    # pending, failed, finished
    $scope.loading_status = 'pending'
    $scope.sorting = {active: true}

    updatePaginationControls = (headers) ->
      $scope.current_page = parseInt(headers('X-Page')) or 0
      $scope.per_page     = parseInt(headers('X-Per-Page')) or 15
      $scope.total_count  = parseInt(headers('X-Total-Count')) or 0

    $scope.pluralize = (count, label) ->
      return '' if typeof count is not 'number' or not label?.length
      "#{count} #{pluralize(label, count)}"

    $scope.cityAndPostcode = (listing) ->
      city     = _.trim listing?.city
      postcode = _.trim listing?.postcode
      _([city, postcode]).compact().join(', ')

    $scope.selectedId = (listing) ->
      {applicationId: listing.applications.selected_id}

    $scope.canFetchMoreData = ->
      $scope.loading_status isnt 'pending' and $scope.hasMoreData()

    $scope.hasMoreData = ->
      $scope.total_count > $scope.current_page * $scope.per_page

    $scope.toggleListing = (listing) ->
      listing.expanded = not listing.expanded
      if listing.expanded
        $timeout -> $window.dispatchEvent(new Event('resize'))

    $scope.propertyLocation = (listing) ->
      "[#{listing.property.latitude}, #{listing.property.longitude}]"

    $scope.fetchData = ->
      $scope.loading_status = 'pending'
      url = '/tenant/listings/'
      config = {
        params: {
          active: $scope.sorting.active
          page: $scope.current_page + 1,
          per_page: $scope.per_page
          sort_by: $scope.sorting.column
          sort_order: $scope.sorting.order
        }
      }
      api.get(url, config)
        .success (response, status, headers) ->
          $scope.listings = $scope.listings.concat(response.data)
          $scope.loading_status = 'finished'
          updatePaginationControls(headers)
        .error (response) ->
          $scope.loading_status = 'failed'

    $scope.$watch 'sorting', $scope.fetchData, true


angular
  .module('appForm')
  .controller('DashboardController', DashboardController)
