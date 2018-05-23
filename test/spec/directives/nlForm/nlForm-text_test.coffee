describe 'nlForm.text', ->

  $compile = null
  elem = null
  isolatedScope = null
  pageScope = null
  subline = 'For example: <em>Los Angeles</em> or <em>New York</em>'
  template = '''
    <nl-text value="city" placeholder="any city"
             subline="{{ subline }}" name="city">
    </nl-text>
  '''

  getCompiledElement = (template) ->
    element = angular.element(template)
    compiledElement = $compile(element)(pageScope)
    pageScope.$digest()
    compiledElement

  beforeEach ->
    module('appTemplates')
    module('pt.nlForm.text')

    inject ($injector) ->
      $compile = $injector.get('$compile')
      pageScope = $injector.get('$rootScope').$new()

    elem = getCompiledElement(template)
    isolatedScope = elem.children().scope()

  describe 'Directive', ->
    wrapper = null

    beforeEach ->
      wrapper = elem.find('.nl-field-items')

    it 'creates the root element', ->
      expect(elem.html()).not.toEqual('')
      expect(elem).toHaveClass 'nl-field'
      expect(elem).toHaveClass 'nl-text'

    it 'creates the input element', ->
      input = wrapper.find('.nl-text-input')
      expect(input.find('input[type="text"]').length).toBe 1
      expect(input.find('input[type="text"]').prop('name')).toBe 'city'
      expect(input.find('button').length).toBe 1
      expect(input.find('button')).toHaveClass 'nl-field-submit'

    it 'creates the subline element', ->
      pageScope.$apply ->
        pageScope.subline = subline
      expect(wrapper.find('.nl-text-subline').length).toBe 1
      expect(wrapper.find('.nl-text-subline').html()).toContain 'Los Angeles'
      expect(wrapper.find('.nl-text-subline').css('display')).not.toBe 'none'

    it 'creates a sibling element for the overlay', ->
      expect(elem.find('.nl-overlay').length).toBe 1

    it 'shows the placeholder text', ->
      expect(elem.find('.nl-field-toggle').text()).toBe 'any city'
      expect(elem.find('input').val()).toBe ''

    it 'shows the correct value in the input and the view', ->
      pageScope.$apply ->
        pageScope.city = 'blah'
      expect(elem.find('.nl-field-toggle').text()).toBe 'blah'
      expect(elem.find('input').val()).toBe 'blah'

    it 'does not show the subline', ->
      pageScope.$apply ->
        pageScope.subline = ''
      expect(wrapper.find('.nl-text-subline').html()).toBe ''
      expect(wrapper.find('.nl-text-subline')).toHaveClass 'ng-hide'

    it 'is not opened', ->
      expect(elem).not.toHaveClass 'nl-field-open'


    describe 'when clicked', ->
      beforeEach ->
        elem.find('.nl-field-toggle').click()

      it 'opens', ->
        expect(elem).toHaveClass 'nl-field-open'

      it 'closes when the button is clicked', ->
        elem.find('button').click()
        expect(elem).not.toHaveClass 'nl-field-open'

      it 'closes when the overlay is clicked', ->
        elem.find('.nl-overlay').click()
        expect(elem).not.toHaveClass 'nl-field-open'

      it 'is not touched', ->
        expect(elem).not.toHaveClass 'nl-touched'

      it 'is touched after closing', ->
        elem.find('.nl-overlay').click()
        expect(elem).toHaveClass 'nl-touched'


  describe 'Controller', ->
    beforeEach inject(($rootScope, $controller) ->
      pageScope.value = ''
      pageScope.placeholder = 'anything'
      $controller('NLTextController', {$scope: pageScope})
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

      it 'shows the new value in the view', ->
        pageScope.$apply -> pageScope.value = 'woot'
        expect(pageScope.viewValue()).toBe 'woot'

    describe 'scope.open', ->
      beforeEach ->
        pageScope.$apply -> pageScope.open {stopPropagation: -> return}

      it 'sets opened to true', ->
        expect(pageScope.opened).toBeTruthy()

      it 'is not touched', ->
        expect(pageScope.touched).toBeFalsy()

    describe 'scope.close', ->
      beforeEach ->
        pageScope.$apply -> pageScope.close()

      it 'sets opened to false', ->
        expect(pageScope.opened).toBeFalsy()

      it 'is now touched', ->
        expect(pageScope.touched).toBeTruthy()
