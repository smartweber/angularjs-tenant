( ->
  class AppMainController
    @$inject = ['$scope', '$state', '$auth', 'api']

    constructor: ($scope, $state, $auth, api) ->

      $scope.signOut = ->
        $auth.signOut() and $state.go 'signin.index'



  angular.module('appForm').controller 'AppMainController', AppMainController
)()
