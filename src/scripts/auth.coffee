angular.module('appForm')
.config [
  '$httpProvider'
  '$authProvider'
  'appConfig'
  ($httpProvider, $authProvider, appConfig) ->
    $httpProvider.defaults.headers.common['Accept'] = ';version=2'

    $authProvider.configure {
      apiUrl: appConfig.apiUrl
      emailSignInPath: '/tenant/sign_in'
      tokenValidationPath: '/tenant/validate_token'
      signOutUrl: '/tenant/sign_out'
      storage: 'localStorage'
    }
]
