describe 'DashboardController', ->
  $scope = null
  $httpBackend = null

  beforeEach ->
    module 'appForm'

  beforeEach inject ($rootScope, $controller, _$httpBackend_, _appConfig_) ->
    $scope = $rootScope.$new()
    $controller('DashboardController', {$scope: $scope})

    $httpBackend = _$httpBackend_
    $httpBackend.whenRoute 'GET', _appConfig_.apiUrl + '/tenant/listings'
      .respond (method, url, data, headers, params) ->
        return [500] if params.active is 'false'
        listing = if params.sort_order is 'ascending'
          {id: 42, street: 'Elm St'}
        else
          {id: 43, street: 'Koontz St'}
        [200, {data: [listing]}]

  describe 'pluralize()', ->
    it 'should be defined', ->
      expect($scope.pluralize).toBeDefined()

    it 'should produce singular form when value is 1', ->
      expect($scope.pluralize(1, 'application')).toBe('1 application')

    it 'should produce plural form when value is different from 1', ->
      expect($scope.pluralize(33, 'application')).toBe('33 applications')
      expect($scope.pluralize(33, 'viewing')).toBe('33 viewings')
      expect($scope.pluralize(0, 'application')).toBe('0 applications')

    it 'should produce empty string when incorrect value is provided', ->
      expect($scope.pluralize(true)).toBe('')
      expect($scope.pluralize('42')).toBe('')
      expect($scope.pluralize(null)).toBe('')

    it 'should produce empty string when no or empty label is provided', ->
      expect($scope.pluralize(true, null)).toBe('')
      expect($scope.pluralize(11, '')).toBe('')

  describe 'selectedId()', ->
    it 'should be defined', ->
      expect($scope.selectedId).toBeDefined()

    it 'should return hash with selected application id', ->
      listing = {applications: {selected_id: 42}}
      expect($scope.selectedId(listing).applicationId).toBe(42)

  describe 'cityAndPostcode()', ->
    it 'should be defined', ->
      expect($scope.cityAndPostcode).toBeDefined()

    it 'should produce empty string when both fields is missing', ->
      expect($scope.cityAndPostcode()).toBe('')

    it 'should join city and postcode, separated by comma', ->
      listing = {city: 'London', postcode: '123 456'}
      expect($scope.cityAndPostcode(listing)).toBe('London, 123 456')

    it 'ignores extra whitespace on city and postcode', ->
      listing = {city: ' London ', postcode: ' 123 456 '}
      expect($scope.cityAndPostcode(listing)).toBe('London, 123 456')

    it 'should omit comma if any field is missing', ->
      city = 'London'; postcode = '123 456'
      expect($scope.cityAndPostcode({city: city})).toBe(city)
      expect($scope.cityAndPostcode({postcode: postcode})).toBe(postcode)

  describe 'toggleListing()', ->
    it 'should be defined', ->
      expect($scope.toggleListing).toBeDefined()

    it 'should set expanded to true', ->
      listing = {}
      $scope.toggleListing(listing)
      expect(listing.expanded).toBe(true)

    it 'should inverse expanded if present', ->
      listing = {expanded: true}
      $scope.toggleListing(listing)
      expect(listing.expanded).toBe(false)

  describe 'propertyLocation()', ->
    it 'should be defined', ->
      expect($scope.propertyLocation).toBeDefined()

    it 'should return array of latitude and longitude of property', ->
      listing = {property: {latitude: 12, longitude: 34}}
      expect($scope.propertyLocation(listing)).toBe('[12, 34]')

  describe 'fetchData()', ->
    mockFetchData = ->
      $scope.fetchData() and $httpBackend.flush()

    it 'should be defined', ->
      expect($scope.fetchData).toBeDefined()

    it 'should request listings from backend', ->
      mockFetchData()
      expect($scope.listings).toBeDefined()
      expect($scope.listings[0].id).toBe(43)
      expect($scope.listings[0].street).toBe('Koontz St')

    it 'should supply sorting attributes with request', ->
      $scope.sorting.order = 'ascending'
      mockFetchData()
      expect($scope.listings).toBeDefined()
      expect($scope.listings[0].id).toBe(42)
      expect($scope.listings[0].street).toBe('Elm St')

    it 'should set status to pending while waiting for response', ->
      $scope.loading_status = 'finished'
      $scope.fetchData()
      expect($scope.loading_status).toBe('pending')

    it 'should set status to finished when backend responded successfully', ->
      mockFetchData()
      expect($scope.loading_status).toBe('finished')

    it 'should set status to failed when backend returned error', ->
      $scope.sorting.active = false
      mockFetchData()
      expect($scope.loading_status).toBe('failed')

  describe 'canFetchMoreData', ->
    it 'is defined', ->
      expect($scope.canFetchMoreData).toBeDefined()

    it 'is false when a request is in flight', ->
      spyOn($scope, 'loading_status').and.returnValue('pending')
      expect($scope.canFetchMoreData()).toBeFalse()

    it 'is false when there is no more data', ->
      spyOn($scope, 'hasMoreData').and.returnValue(false)
      expect($scope.canFetchMoreData()).toBeFalse()

    it 'is true when there is no request and there is more data', ->
      spyOn($scope, 'loading_status').and.returnValue('finished')
      spyOn($scope, 'hasMoreData').and.returnValue(true)
      expect($scope.canFetchMoreData()).toBeTrue()

  describe 'hasMoreData', ->
    it 'is defined', ->
      expect($scope.hasMoreData).toBeDefined()

    it 'is true when total_count doesnt exceed current_page * per_page', ->
      $scope.current_page = 3
      $scope.per_page = 5
      $scope.total_count = 14
      expect($scope.hasMoreData()).toBeFalse()

    it 'is false when total_count equals current_page * per_page', ->
      $scope.current_page = 3
      $scope.per_page = 5
      $scope.total_count = 15
      expect($scope.hasMoreData()).toBeFalse()

    it 'is false when total_count exceeds current_page * per_page', ->
      $scope.current_page = 3
      $scope.per_page = 5
      $scope.total_count = 16
      expect($scope.hasMoreData()).toBeTrue()
