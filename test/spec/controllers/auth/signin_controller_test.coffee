describe 'SigninController', ->

  email = 'test@example.com'
  httpBackend = null
  scope = null
  state = null

  beforeEach ->
    module 'appForm'

  beforeEach(
    inject ($rootScope, $controller, $httpBackend, $state, appConfig) ->
      state = $state
      scope = $rootScope.$new()
      httpBackend = $httpBackend
      $controller 'SigninController', {$scope: scope}
      state.go 'signin.index'

      httpBackend.expectPOST appConfig.apiUrl + '/tenant/sign_in'
        .respond (method, url, data, headers, params) ->
          data = JSON.parse data if typeof data is 'string'
          if data?.email is email then [200, {}] else [401, {}]
  )

  afterEach ->
    window.localStorage.clear()

  describe 'signIn()', ->
    signIn = -> scope.signIn() and httpBackend.flush()

    it 'should be defined', ->
      expect(scope.signIn).toBeDefined()

    describe 'without credentials', ->
      beforeEach -> signIn()

      it 'should have errors', ->
        expect(scope.errors).toBeArray()

      it 'should not redirect', ->
        expect(state.current.name).toBe('signin.index')

    describe 'with correct credentials', ->
      beforeEach ->
        scope.signinForm = {email: email}
        signIn()

      it 'should have no errors', ->
        expect(scope.errors).toBeUndefined()

      it 'should redirect to the dashboard', ->
        expect(state.current.name).toBe('app.main.dashboard')
