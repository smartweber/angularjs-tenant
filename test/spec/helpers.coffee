authenticateEach = ->
  beforeEach inject ($auth, $httpBackend, appConfig) ->
    signinPath = "#{appConfig.apiUrl}/tenant/sign_in"
    $httpBackend.expectPOST(signinPath).respond(200, {})
    $auth.submitLogin() and $httpBackend.flush()

  afterEach -> window.localStorage.clear()

beforeEach ->
  jasmine.addMatchers {
    toHaveClass: (util, customEqualityTesters) -> {
      compare: (obj, expected) ->
        passed = obj.hasClass(expected)
        {
          pass: passed
          message: "Expected #{obj} to have class #{expected}"
        }
    }
  }

  # Determine the length of the given associative JS object
  # @param obj a javascript object
  # @returns int
  Object.size = (obj) ->
    size = 0
    for key of obj
      if obj.hasOwnProperty(key)
        size = size + 1
    size
