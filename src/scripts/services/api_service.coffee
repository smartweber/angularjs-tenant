class ApiService
  @$inject: ['$http', 'appConfig']

  constructor: ($http, appConfig) ->
    @$http = $http
    @backendUrl = appConfig.apiUrl

  request: (method, endpoint, data, config) ->
    _config = {
      method: method
      url: @backendUrl + endpoint
      data: data
    }
    @$http _.defaults _config, config

  get: (endpoint, config) ->
    @request 'GET', endpoint, undefined, config

  post: (endpoint, data, config) ->
    @request 'POST', endpoint, data, config

  put: (endpoint, data, config) ->
    @request 'PUT', endpoint, data, config

  delete: (endpoint, config) ->
    @request 'DELETE', endpoint, undefined, config



angular.module('appForm').service('api', ApiService)
