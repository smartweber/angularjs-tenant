describe 'nlForm.field', ->

  $compile = null
  element = null
  pageScope = null

  template = """
    <nl-field placeholder="'a placeholder expression'">
      <span>Arbitrary content</span>
    </nl-field>
  """

  getCompiledElement = (template) ->
    element = angular.element(template)
    compiledElement = $compile(element)(pageScope)
    pageScope.$digest()
    compiledElement

  beforeEach ->
    module('appTemplates')
    module('pt.nlForm.field')

    inject ($injector) ->
      $compile = $injector.get('$compile')
      pageScope = $injector.get('$rootScope').$new()

    element = getCompiledElement(template)

  describe 'Directive', ->
    it 'creates the root element', ->
      expect(element.html()).not.toEqual('')
      expect(element).toHaveClass 'nl-field'

    it 'creates the toggle element', ->
      expect(element.find('.nl-field-toggle').length).toBe 1

    it 'creates the element for transclusion', ->
      expect(element.find('[ng-transclude]').length).toBe 1

    it 'shows the placeholder text', ->
      expect(element.find('.nl-field-toggle').text())
      .toEqual 'a placeholder expression'

    it 'creates an element for the overlay', ->
      expect(element.find('.nl-overlay').length).toBe 1

    describe 'when clicked', ->
      beforeEach -> element.find('.nl-field-toggle').click()

      it 'sets the css class', ->
        expect(element.length).toBe 1
        expect(element).toHaveClass 'nl-field-open'

      it 'shows the transcluded contents', ->
        contents = element.find('[ng-transclude]')
        expect(contents.length).toBe 1
        expect(contents.html()).toContain '</span>'
        expect(contents.html()).toContain 'Arbitrary content'

      it 'closes when the overlay is clicked', ->
        element.find('.nl-overlay').click()
        expect(element.length).toBe 1
        expect(element).not.toHaveClass 'nl-field-open'

  describe 'Controller', ->
    beforeEach inject(($controller) ->
      pageScope.placeholder = 'anything'
      pageScope.name = 'blah'
      Controller = $controller('NLFieldController', {$scope: pageScope})
      pageScope.$digest()
    )

    it 'is not opened', ->
      expect(pageScope.opened).toBeFalsy()

    describe 'scope.viewValue', ->
      it 'shows the placeholder', ->
        expect(pageScope.viewValue()).toBe 'anything'

      it 'shows the new placeholder value when updated', ->
        pageScope.$apply -> pageScope.placeholder = 'woot'
        expect(pageScope.viewValue()).toBe 'woot'

    describe 'scope.open', ->
      beforeEach ->
        pageScope.$apply -> pageScope.open {stopPropagation: -> return}
      it 'sets opened to true', ->
        expect(pageScope.opened).toBeTruthy()

    describe 'scope.close', ->
      beforeEach -> pageScope.$apply pageScope.close
      it 'sets opened to false', ->
        expect(pageScope.opened).toBeFalsy()
