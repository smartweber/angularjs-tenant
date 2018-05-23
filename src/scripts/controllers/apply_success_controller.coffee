class ApplySuccessController
  @$inject: ['$scope', '$state']

  constructor: ($scope, $state) ->

    $scope.ok = ->
      $state.go('app.main.dashboard')



angular
  .module('appForm')
  .controller('ApplySuccessController', ApplySuccessController)
