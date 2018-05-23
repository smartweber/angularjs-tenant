describe 'Routes', ->
  $state = null
  basePath = ''

  beforeEach ->
    module('appForm')
    inject (_$state_) ->
      $state = _$state_

  describe 'app', ->
    beforeEach ->
      basePath = 'app/'

    it 'defines an abstract parent state', ->
      state = $state.get('app')
      expect(state.abstract).toEqual true
      expect(state.templateUrl).toEqual(basePath + 'layout.html')

    describe 'main', ->
      beforeEach ->
        basePath = 'app/main/'

      it 'defines an abstract parent state', ->
        state = $state.get('app.main')
        expect(state.abstract).toEqual true
        expect(state.templateUrl).toEqual(basePath + 'layout.html')

    describe 'errors', ->
      beforeEach ->
        basePath = 'app/errors/'

      it 'defines an abstract parent state', ->
        state = $state.get('app.errors')
        expect(state.abstract).toEqual true
        expect(state.templateUrl).toEqual(basePath + 'layout.html')

      it 'routes to forbidden', ->
        state = $state.get('app.errors.forbidden')
        expect(state.url).toEqual('/403')
        expect(state.templateUrl).toEqual(basePath + 'forbidden.html')

      it 'routes to notFound', ->
        state = $state.get('app.errors.notFound')
        expect(state.url).toEqual('/404')
        expect(state.templateUrl).toEqual(basePath + 'not_found.html')

      it 'routes to comingSoon', ->
        state = $state.get('app.errors.comingSoon')
        expect(state.url).toEqual('/coming_soon')
        expect(state.templateUrl).toEqual(basePath + 'coming_soon.html')

  describe 'apply', ->
    beforeEach ->
      basePath = 'apply/'

    it 'routes to form', ->
      state = $state.get('apply.form')
      expect(state.url).toEqual('/apply/:listingId')
      expect(state.controller).toEqual('ApplicationsController')
      expect(state.templateUrl).toEqual(
        basePath + 'form.html'
      )

    it 'routes to success', ->
      state = $state.get('apply.success')
      expect(state.url).toEqual('/apply-success')
      expect(state.controller).toEqual('ApplySuccessController')
      expect(state.templateUrl).toEqual(
        basePath + 'success.html'
      )
