App.controller('ApplicationsController', [
  '$scope', '$state', 'api',
  ($scope, $state, api) ->
    # Deeply merges properties from src into dst
    # Defined properties in dst will be preserved
    # Reference to dst (and child objects) is preserved
    mergeAttrs = (dst, src) ->
      angular.forEach src, (value, key) ->
        if dst[key] and dst[key].constructor is Object
          mergeAttrs dst[key], value
        else if dst[key] is undefined
          dst[key] = value
        return
      return

    buildPayload = (obj) ->
      tenants = obj.otherTenants.tenants
      for tenant in tenants
        tenant.employment_details = "#{tenant.employment_status} #{tenant.job}"
      minors = _.compact tenants.map (o) ->
        if not o.is_adult then o.name else null
      applicants = tenants.filter (o) -> o.is_adult
      {
        lead_applicant: obj.lead_applicant
        monthly_rent: obj.payment.monthly_rent
        advance_rent_months: obj.payment.advance_rent_months
        lease_duration_months: 12
        lease_starts_on: obj.payment.lease_starts_on
        pets: if obj.user.hasPets then 'Yes' else 'No'
        requests: obj.user.additional_request
        why_us: obj.user.bio
        minors: minors
        applicants: applicants
      }

    # pending, failed, finished
    $scope.loading_status = 'pending'
    $scope.submit_status = null

    $scope.agent = null
    $scope.listing = null

    # When the user clicks the close, set this to true
    $scope.wantsToExit = false

    # Base form object to hold the input values
    $scope.form = {}
    $scope.partialsPrefix = 'apply/form/'
    $scope.currentSectionIdx = 2
    $scope.sections = [
      {
        parts: [
          '_2-employment.html'
          '_3-smoker.html'
        ]
      }
      {
        parts: [
          '_5-tenants.html'
        ]
      }
      {
        parts: [
          '_6-tenants-contacts.html'
        ]
      }
      {
        parts: [
          '_7-payment-and-lease.html'
        ]
      }
      {
        parts: [
          '_8-pets.html'
          '_9-additional-requests.html'
          '_10-extra-info.html'
        ]
      }
    ]

    # Returns a references to an object inside the form
    # Sets the attributes if they are undefined
    $scope.getFormChildObject = (name, attrs) ->
      if $scope.form.hasOwnProperty(name) is false
        $scope.form[name] = attrs
      if attrs and attrs.constructor is Object
        mergeAttrs $scope.form[name], attrs
      $scope.form[name]

    $scope.nextSection = ->
      $scope.currentSectionIdx += 1

    $scope.previousSection = ->
      $scope.currentSectionIdx -= 1

    $scope.promptExit = ->
      $scope.wantsToExit = true

    $scope.exit = ->
      $state.go('app.main.dashboard')

    $scope.stay = ->
      $scope.wantsToExit = false

    $scope.submit = ->
      return if $scope.submit_status is 'pending'
      $scope.submit_status = 'pending'
      url = "/tenant/listings/#{$state.params.listingId}/applications"
      data = buildPayload($scope.form)
      api.post(url, data)
        .success (response) ->
          $scope.submit_status = 'finished'
          $state.go('apply.form')
        .error (response) ->
          $scope.submit_status = 'failed'

    $scope.fetchData = ->
      $scope.loading_status = 'pending'
      url = "/listings/#{$state.params.listingId}"
      api.get(url)
        .success (response) ->
          $scope.agent = response.data.agent
          $scope.listing = response.data.listing
          $scope.loading_status = 'finished'
        .error (response) ->
          $scope.loading_status = 'failed'

    $scope.fetchData()
])
