class ListingService
  constructor: ->
    return

  offerState: (listing) ->
    # my_viewing.status: [new, accepted, failed, completed]
    # my_application.status: [new, selected,...]
    if listing?.my_viewing?.status is 'new'
      'new_viewing'
    else if listing?.my_viewing?.status is 'completed'
      if listing?.applications?.count is 0
        'no_applications'
      else
        if listing?.my_application?.status is 'selected'
          'application_selected'
        else
          'with_applications'



angular.module('appForm').service('listing', ListingService)
