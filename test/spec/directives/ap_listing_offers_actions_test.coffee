describe 'apListingOffersActions', ->

  $compile = null
  directiveElem = null
  pageScope = null

  template = '''
    <ap-listing-offers-actions ng-model="listing"></ap-listing-offers-actions>
  '''

  getCompiledElement = (template) ->
    element = angular.element(template)
    compiledElement = $compile(element)(pageScope)
    pageScope.$digest()
    compiledElement

  beforeEach ->
    module('appTemplates')
    module('appForm')

    inject ($injector) ->
      $compile = $injector.get('$compile')
      pageScope = $injector.get('$rootScope').$new()

    directiveElem = getCompiledElement(template)

  describe 'Directive', ->
    it 'creates the root element', ->
      expect(directiveElem.html()).not.toEqual('')

    it 'has a "div" as its base element', ->
      expect(directiveElem.get(0).tagName.toLowerCase()).toEqual('div')

    describe 'with a listing', ->
      it 'creates the root element', ->
        expect(directiveElem.html()).not.toEqual('')

    describe 'ngModel', ->
      it 'is undefined', ->
        expect(pageScope.ngModel).toBeFalsy()

  describe 'Controller', ->

    describe 'state', ->
      digestController = ->
        inject(($controller) ->
          Controller = $controller('APListingOffersActionsController', {
            $scope: pageScope
          })
          pageScope.$digest()
        )

      it 'is undefined without a model', ->
        pageScope.ngModel = null
        digestController()
        expect(pageScope.state).toBe(undefined)

      it 'is new_viewing when my_viewing.status is "new"', ->
        pageScope.ngModel = {
          my_viewing: {status: 'new'}
        }
        digestController()
        expect(pageScope.state).toBe('new_viewing')

      it 'is no_applications when my_viewing.status is "completed" and \
          applications.count is 0', ->
        pageScope.ngModel = {
          my_viewing: {status: 'completed'}
          applications: {count: 0}
        }
        digestController()
        expect(pageScope.state).toBe('no_applications')

      it 'is with_applications when my_viewing.status is "completed" and \
          applications.count is not 0', ->
        pageScope.ngModel = {
          my_viewing: {status: 'completed'}
          applications: {count: 1}
        }
        digestController()
        expect(pageScope.state).toBe('with_applications')

      it 'is application_selected when my_viewing.status is "completed" and \
          applications.count is not 0', ->
        pageScope.ngModel = {
          my_viewing: {status: 'completed'}
          my_application: {status: 'selected'}
        }
        digestController()
        expect(pageScope.state).toBe('application_selected')
