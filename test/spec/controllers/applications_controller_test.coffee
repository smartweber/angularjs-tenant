'use strict'
describe 'ApplicationsController', ->

  $controller = null
  $scope = null

  beforeEach ->
    module('appForm')
    inject (_$controller_) ->
      $controller = _$controller_

  it 'is defined', inject(($controller) ->
    controller = $controller 'ApplicationsController', {$scope: {}}
    expect(controller).toBeDefined()
  )

  describe '$scope.nextSection()', ->
    beforeEach ->
      $scope = {}
      controller = $controller 'ApplicationsController',
        {$scope: $scope}

    it 'increases the section index', ->
      $scope.currentSectionIdx = 1
      expect($scope.currentSectionIdx).toBe(1)
      $scope.nextSection()
      expect($scope.currentSectionIdx).toBe(2)

  describe '$scope.previousSection()', ->
    beforeEach ->
      $scope = {}
      controller = $controller 'ApplicationsController',
        {$scope: $scope}

    it 'dencreases the section index', ->
      $scope.currentSectionIdx = 1
      expect($scope.currentSectionIdx).toBe(1)
      $scope.previousSection()
      expect($scope.currentSectionIdx).toBe(0)

  describe '$scope.getFormChildObject()', ->
    beforeEach ->
      $scope = {}
      controller = $controller 'ApplicationsController',
        {$scope: $scope}

    it 'returns a reference to an object in the form', ->
      expect($scope.form).toEqual({})
      obj = $scope.getFormChildObject('something')
      expect($scope.form).toEqual({something: undefined})
      expect(obj).toBe($scope.form.something)

      $scope.form = {foo: [1, 2, 3]}
      obj = $scope.getFormChildObject('foo')
      expect($scope.form).toEqual({foo: [1, 2, 3]})
      expect(obj).toBe($scope.form.foo)

    it 'merges additional attributes', ->
      $scope.form = {}
      obj = $scope.getFormChildObject('something', false)
      expect(obj).toEqual(false)

      $scope.form = {}
      obj = $scope.getFormChildObject('something', 'foo')
      expect(obj).toEqual('foo')

      $scope.form = {}
      obj = $scope.getFormChildObject('something', [1])
      expect(obj).toEqual([1])

      $scope.form = {}
      obj = $scope.getFormChildObject('something', {foo: 'bar'})
      expect(obj).toEqual({foo: 'bar'})

    it 'merges additional attributes preserving existing ones', ->
      $scope.form = {something: 'foo'}
      obj = $scope.getFormChildObject('something', [1])
      expect(obj).toEqual('foo')

      $scope.form = {something: [1, 2, 3]}
      obj = $scope.getFormChildObject('something', [1])
      expect(obj).toEqual([1, 2, 3])

      $scope.form = {something: {foo: 'bar'}}
      obj = $scope.getFormChildObject('something', [1])
      expect(obj).toEqual({foo: 'bar'})

      $scope.form = {something: {foo: 'bar'}}
      obj = $scope.getFormChildObject('something-else', {bar: 'foo'})
      expect(obj).toEqual({bar: 'foo'})
      expect($scope.form).toEqual({
        something: {foo: 'bar'},
        'something-else': {bar: 'foo'}
      })
