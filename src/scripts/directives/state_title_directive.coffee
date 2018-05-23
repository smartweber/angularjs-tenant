angular.module('appForm').directive 'stateTitle', [
  '$rootScope', '$state', ($rootScope, $state) ->
    {
      restrict: 'A'
      scope: {
        stateTitle: '='
      }
      link: (scope, element, attrs) ->
        scope.update = (state) ->
          element.html [
            scope.stateTitle?.prefix
            state.title
            scope.stateTitle?.postfix
          ].join('')

        scope.stateChangeCallback = (event, toState) ->
          scope.update toState

        scope.update($state.current)
        scope.$on '$stateChangeSuccess', scope.stateChangeCallback
    }
]
