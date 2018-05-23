triggerableElements = '''
  .dropdown .dropdown-button,
  .dropdown .dropdown-button *,
  .dropdown .dropdown-content a,
  .dropdown .dropdown-content a *
'''

angular.module('appForm').directive 'dropdown', [
  '$document', ($document) ->
    {
      restrict: 'C'
      link: (scope, element, attrs) ->
        content = element.find('.dropdown-content')
        # TODO: do this well - do not listen to clicks on document...
        $document.on 'click', (event) ->
          child = element.find(event.target)[0]
          return content.removeClass 'show' unless child?
          content.toggleClass 'show' if $(child).is(triggerableElements)
    }
]
