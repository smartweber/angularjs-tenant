describe 'ListingService', ->

  listing = null

  beforeEach ->
    module 'appForm'

  beforeEach inject (_listing_) ->
    listing = _listing_

  it 'should be defined', ->
    expect(listing).toBeDefined()


  describe 'offerState()', ->
    it 'is undefined without a model', ->
      model = null
      expect(listing.offerState(model)).toBe(undefined)

    it 'is new_viewing when my_viewing.status is "new"', ->
      model = {
        my_viewing: {status: 'new'}
      }
      expect(listing.offerState(model)).toBe('new_viewing')

    it 'is no_applications when my_viewing.status is "completed" and \
        applications.count is 0', ->
      model = {
        my_viewing: {status: 'completed'}
        applications: {count: 0}
      }
      expect(listing.offerState(model)).toBe('no_applications')

    it 'is with_applications when my_viewing.status is "completed" and \
        applications.count is not 0', ->
      model = {
        my_viewing: {status: 'completed'}
        applications: {count: 1}
      }
      expect(listing.offerState(model)).toBe('with_applications')

    it 'is application_selected when my_viewing.status is "completed" and \
        applications.count is not 0', ->
      model = {
        my_viewing: {status: 'completed'}
        my_application: {status: 'selected'}
      }
      expect(listing.offerState(model)).toBe('application_selected')
