describe 'AppMainController', ->

  $controller = null
  $scope = null

  beforeEach ->
    module('appForm')
    inject (_$controller_) ->
      $controller = _$controller_

  it 'is defined', inject(($controller) ->
    controller = $controller 'AppMainController', {$scope: {}}
    expect(controller).toBeDefined()
  )
