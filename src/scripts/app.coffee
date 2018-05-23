'use strict'
window.App = angular.module('appForm', [
  'angular-fallback-image'
  'appConfig' # auto-generated by ngConstant based on src/config.json
  'appTemplates'
  'ng-token-auth'
  'ngAnimate'
  'ngDialog'
  'ngMap'
  'infinite-scroll'
  'perfect_scrollbar'
  'pt.nlForm'
  'ui.router'
])
App.config [
  '$compileProvider', 'appConfig'
  ($compileProvider, appConfig) ->
    $compileProvider.debugInfoEnabled appConfig.env is 'development'
]
angular.module('infinite-scroll').value('THROTTLE_MILLISECONDS', 1000)