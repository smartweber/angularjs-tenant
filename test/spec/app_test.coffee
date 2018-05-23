'use strict'
describe 'appForm module', ->
  beforeEach ->
    module('appForm')

  it 'defines the main angular app', inject ->
    expect(window.App).toBeDefined()

  it 'loads appConfig', inject((appConfig) ->
    expect(appConfig).toBeDefined()
    expect(appConfig.apiUrl).toBeDefined()
    expect(appConfig.env).toBeDefined()
  )
