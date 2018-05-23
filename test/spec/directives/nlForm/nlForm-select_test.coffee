describe 'nlForm.select', ->
  $compile  = null
  elem      = null
  pageScope = null
  template  = '<nl-select options="options" value="value"></nl-select>'

  getCompiledElement = (template) ->
    element = angular.element(template)
    compiledElement = $compile(element)(pageScope)
    pageScope.$digest()
    compiledElement

  beforeEach ->
    module('appTemplates')
    module('pt.nlForm.select')

    inject ($injector) ->
      $compile = $injector.get('$compile')
      pageScope = $injector.get('$rootScope').$new()

  describe 'Directive', ->

    describe 'init', ->
      beforeEach ->
        elem = getCompiledElement(template)

      it 'creates the root element', ->
        expect(elem.html()).not.toEqual('')
        expect(elem).toHaveClass 'nl-field'
        expect(elem).toHaveClass 'nl-select'

      it 'creates a sibling element for the overlay', ->
        expect(elem.find('.nl-overlay').length).toBe 1

      it 'is not opened', ->
        expect(pageScope.opened).toBeFalsy()
        expect(elem).not.toHaveClass 'nl-field-open'

      it 'is not touched', ->
        expect(pageScope.touched).toBeFalsy()
        expect(elem).not.toHaveClass 'nl-touched'

    describe 'with a simple array', ->
      beforeEach ->
        pageScope.options = ['one', 'two', 'three']
        pageScope.value = 'one'
        elem = getCompiledElement(template)

      it 'creates a list of options', ->
        options = elem.find('.nl-field-item')
        # +2 to account for 'all' and 'none' options
        expect(options.length).toBe pageScope.options.length + 2
        # this is not a multi-select, so the 'all' option should be hidden
        expect(options.eq(0)).toHaveClass 'ng-hide'
        # this is not a multi-select, so the 'none' option should be hidden
        expect(options.eq(4)).toHaveClass 'ng-hide'
        expect(options.eq(1).text()).toBe 'one'
        expect(options.eq(2).text()).toBe 'two'
        expect(options.eq(3).text()).toBe 'three'

      it 'creates an element for the overlay', ->
        expect(elem.find('.nl-overlay').length).toBe 1

    describe 'with an array of objects', ->
      beforeEach ->
        pageScope.options = [
          {label: 'one',   value: 'ten'}
          {label: 'two',   value: 'nine'}
          {label: 'three', value: 'eight'}
        ]
        pageScope.value = 'nine'
        elem = getCompiledElement(template)

      it 'creates a list of options', ->
        options = elem.find('.nl-field-item')
        expect(options.length).toBe pageScope.options.length + 2
        expect(options.eq(1).text()).toBe 'one'
        expect(options.eq(2).text()).toBe 'two'
        expect(options.eq(3).text()).toBe 'three'
        expect(options.eq(2)).toHaveClass 'nl-select-checked'
        expect(elem.find('.nl-field-toggle').text()).toBe 'two'

      it 'creates an element for the overlay', ->
        expect(elem.find('.nl-overlay').length).toBe 1

    describe 'with an object of values', ->
      beforeEach ->
        pageScope.options = {'one': 'ten', 'two': 'nine', 'three': 'eight'}
        pageScope.value = 'eight'
        elem = getCompiledElement(template)

      it 'creates a list of options', ->
        options = elem.find('.nl-field-item')
        expect(options.length).toBe Object.size(pageScope.options) + 2
        expect(options.eq(1).text()).toBe 'one'
        expect(options.eq(2).text()).toBe 'two'
        expect(options.eq(3).text()).toBe 'three'
        expect(options.eq(3)).toHaveClass 'nl-select-checked'
        expect(elem.find('.nl-field-toggle').text()).toBe 'three'

      it 'creates an element for the overlay', ->
        expect(elem.find('.nl-overlay').length).toBe 1

    describe 'with an object of objects', ->
      beforeEach ->
        pageScope.options = {
          'one': {label: 'one', value: 'ten'}
          'two': {label: 'two', value: 'nine'}
          'three': {label: 'three', value: 'eight'}
        }
        pageScope.value = 'ten'
        elem = getCompiledElement(template)

      it 'creates a list of options', ->
        options = elem.find('.nl-field-item')
        expect(options.length).toBe Object.size(pageScope.options) + 2
        expect(options.eq(1).text()).toBe 'one'
        expect(options.eq(2).text()).toBe 'two'
        expect(options.eq(3).text()).toBe 'three'
        expect(options.eq(1)).toHaveClass 'nl-select-checked'
        expect(elem.find('.nl-field-toggle').text()).toBe 'one'

      it 'creates an element for the overlay', ->
        expect(elem.find('.nl-overlay').length).toBe 1

    describe 'when clicked', ->
      beforeEach ->
        pageScope.options = {'one': 'ten', 'two': 'nine', 'three': 'eight'}
        pageScope.value = 'eight'
        elem = getCompiledElement(template)
        elem.find('.nl-field-toggle').click()

      it 'should open the select', ->
        expect(elem).toHaveClass 'nl-field-open'

      it 'closes when the overlay is clicked', ->
        elem.find('.nl-overlay').click()
        expect(elem.length).toBe 1
        expect(elem).not.toHaveClass 'nl-field-open'

      it 'is not touched', ->
        expect(elem).not.toHaveClass 'nl-touched'

      it 'is touched after closing', ->
        elem.find('.nl-overlay').click()
        expect(elem).toHaveClass 'nl-touched'

      describe 'and an option is selected', ->
        beforeEach -> elem.find('.nl-field-item').eq(1).click()

        it 'closes the overlay', ->
          expect(elem).not.toHaveClass 'nl-field-open'

        it 'shows the selected value', ->
          expect(elem.find('.nl-field-toggle').text()).toBe('one')

  describe 'Controller', ->
    pageScope = null
    beforeEach inject(($rootScope, $controller) ->
      pageScope.options     = {'one': 'ten', 'two': 'nine', 'three': 'eight'}
      pageScope.value       = 'ten'
      pageScope.none        = 'none'
      pageScope.required    = false
      pageScope.multiple    = false
      pageScope.allOptions  = false
      pageScope.conjunction = 'and'
      pageScope.nlSelect    = {$setValidity: jasmine.createSpy('setValidity')}
      $controller('NLSelectController', {$scope: pageScope})
      pageScope.$digest()
    )

    it 'gets the selected text', ->
      expect(pageScope.getSelected()).toBe 'one'

    it 'says one is selected', ->
      expect(pageScope.isSelected('one')).toBeTruthy()

    it 'says two is not selected', ->
      expect(pageScope.isSelected('two')).toBeFalsy()

    it 'sets the value to two', ->
      pageScope.setValue 'two'
      expect(pageScope.value).toBe 'nine'

    it 'removes an option and changes the value to the first one', ->
      pageScope.$apply ->
        pageScope.options = {'two': 'nine', 'three': 'eight'}
      expect(pageScope.value).toEqual 'nine'

    describe 'scope.open', ->
      beforeEach ->
        pageScope.$apply -> pageScope.open {stopPropagation: -> return}
      it 'sets opened to true', ->
        expect(pageScope.opened).toBeTruthy()

      it 'is not touched', ->
        expect(pageScope.touched).toBeFalsy()

    describe 'scope.close', ->
      beforeEach -> pageScope.$apply pageScope.close
      it 'sets opened to false', ->
        expect(pageScope.opened).toBeFalsy()

      it 'is now touched', ->
        expect(pageScope.touched).toBeTruthy()


    describe 'scope.getLabels', ->
      it 'gets the labels', ->
        expect(pageScope.getLabels()).toEqual ['one', 'two', 'three']

      it 'when adding an option to the list keeps the same value', ->
        pageScope.$apply ->
          pageScope.options.four = 'seven'
        expect(pageScope.getLabels()).toEqual ['one', 'two', 'three', 'four']
        expect(pageScope.value).toBe 'ten'

      it 'when removing an option from the list, keeps the same value', ->
        pageScope.$apply ->
          pageScope.options = {'one': 'ten', 'two': 'nine'}
        expect(pageScope.getLabels()).toEqual ['one', 'two']
        expect(pageScope.value).toEqual 'ten'

    describe 'when multiple selections allowed', ->
      beforeEach ->
        pageScope.$apply ->
          pageScope.multiple = true
          pageScope.value = [ pageScope.value ]

      it 'has one option selected', ->
        expect(pageScope.value.length).toBe 1
        expect(pageScope.value).toEqual ['ten']

      it 'gets the selected text for only one option', ->
        expect(pageScope.getSelected()).toBe 'one'

      describe 'and the "all" option is in use', ->
        beforeEach ->
          pageScope.$apply ->
            pageScope.allOptions = 'every'

        it 'should have a visible "all" option', ->
          pageScope.selectAll()
          expect(pageScope.getSelected()).toEqual 'every'
          expect(pageScope.value).toEqual [ 'ten', 'nine', 'eight' ]

      describe 'and at least one is required', ->
        beforeEach ->
          pageScope.$apply ->
            pageScope.required = true
          pageScope.setValue 'one'

        it 'should become invalid', ->
          expect(pageScope.nlSelect.$setValidity)
            .toHaveBeenCalledWith 'required', false

        it 'should become valid again', ->
          pageScope.setValue 'two'
          expect(pageScope.nlSelect.$setValidity)
            .toHaveBeenCalledWith 'required', true

      describe 'and multiple options are selected', ->
        beforeEach ->
          pageScope.setValue 'two'

        it 'should have two options selected', ->
          expect(pageScope.value.length).toBe 2
          expect(pageScope.value).toEqual ['ten', 'nine']

        it 'should get the selected text for both options', ->
          expect(pageScope.getSelected()).toBe 'one and two'

        it 'should say both options are selected', ->
          expect(pageScope.isSelected('one')).toBeTruthy()
          expect(pageScope.isSelected('two')).toBeTruthy()

        it 'then one is deselected should have only one option selected', ->
          pageScope.setValue 'one'
          expect(pageScope.value.length).toBe 1
          expect(pageScope.value).toEqual [ 'nine' ]
          expect(pageScope.isSelected('one')).toBeFalsy()

        it 'then the options list is changed should have only one \
           option selected', ->
          pageScope.$apply ->
            pageScope.options = {'two': 'nine', 'three': 'eight'}
          expect(pageScope.value.length).toBe 1
          expect(pageScope.value).toEqual [ 'nine' ]
