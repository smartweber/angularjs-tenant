describe 'ApiService', ->

  api = null
  backendUrl = null
  httpBackend = null

  beforeEach ->
    module 'appForm'

  beforeEach inject (_api_, _appConfig_, $httpBackend) ->
    api = _api_
    backendUrl = _appConfig_.apiUrl
    httpBackend = $httpBackend

  it 'should be defined', ->
    expect(api).toBeDefined()

  describe 'backendUrl', ->

    it 'should be defined', ->
      expect(api.backendUrl).toBeDefined()

    it 'should equal backendUrl constant', ->
      expect(api.backendUrl).toBe(backendUrl)

  describe 'request()', ->

    it 'should be defined', ->
      expect(api.request).toBeDefined()

    it 'should invoke correct request', ->
      httpBackend.expectPOST(
        backendUrl + '/agent/sign_in', {hello: 'there'}
      ).respond(200)
      api.request('POST', '/agent/sign_in', {hello: 'there'})
      httpBackend.flush()

  describe 'get()', ->

    it 'should be defined', ->
      expect(api.get).toBeDefined()

    it 'should invoke correct get request', ->
      httpBackend.expectGET backendUrl + '/agent/team/?test=hello_world'
        .respond(200)
      api.get '/agent/team/', {params: {test: 'hello_world'}}
      httpBackend.flush()

    it 'should return promise', ->
      promise = api.get('/')
      expect(promise.success).toBeFunction()
      expect(promise.error).toBeFunction()

  describe 'post()', ->

    it 'should be defined', ->
      expect(api.post).toBeDefined()

    it 'should invoke correct post request', ->
      httpBackend.expect(
        'POST'
        backendUrl + '/agent/sign_in/?greeting=howdy!'
        {email: 'mail@example.com'}
      ).respond(200)
      api.post(
        '/agent/sign_in/'
        {email: 'mail@example.com'}
        {params: {greeting: 'howdy!'}}
      )
      httpBackend.flush()

    it 'should return promise', ->
      promise = api.post('/')
      expect(promise.success).toBeFunction()
      expect(promise.error).toBeFunction()

  describe 'put()', ->

    it 'should be defined', ->
      expect(api.put).toBeDefined()

    it 'should invoke correct put request', ->
      httpBackend.expect(
        'PUT'
        backendUrl + '/agent/team/42/?something=something'
        {password: '123'}
      ).respond(200)
      api.put(
        '/agent/team/42/'
        {password: '123'}
        {params: {something: 'something'}}
      )
      httpBackend.flush()

    it 'should return promise', ->
      promise = api.put('/')
      expect(promise.success).toBeFunction()
      expect(promise.error).toBeFunction()

  describe 'delete()', ->

    it 'should be defined', ->
      expect(api.delete).toBeDefined()

    it 'should invoke correct delete request', ->
      httpBackend.expect(
        'DELETE', backendUrl + '/agent/sign_out/?thanks=for_all_the_fish'
      ).respond(200)
      api.delete '/agent/sign_out/', {params: {thanks: 'for_all_the_fish'}}
      httpBackend.flush()

    it 'should return promise', ->
      promise = api.delete('/')
      expect(promise.success).toBeFunction()
      expect(promise.error).toBeFunction()
