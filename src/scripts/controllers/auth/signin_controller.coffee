class SigninController
  @$inject = ['$scope', '$auth', '$state']

  constructor: ($scope, $auth, $state) ->
    $scope.signIn = ->
      $auth.submitLogin($scope.signinForm)
        .then (response) -> $state.go 'app.main.dashboard'
        .catch (response) -> $scope.errors = response.errors



angular
  .module 'appForm'
  .controller 'SigninController', SigninController
