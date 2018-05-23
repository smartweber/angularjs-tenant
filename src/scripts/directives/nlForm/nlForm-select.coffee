# Generates a component with the behaviour of a select element.
# Arguments:
#   value    - [string] Assignable angular expression to data-bind to
#   options  - [string] Expression with the options, can be:
#     * Array of labels/values:  ['one', 'two', 'three', ...]
#     * Array of objects:        [{ label: 'one', value: 'ten' },..]
#     * Object of labels/values: { 'one':'ten', 'two':'nine', ... }
#     * Object of objects:       { 'one':{ label: 'one', value: 'ten' },... }
#   multiple - [string] (optional) Simulates the multiple attribute of a select.
#     The string value given is used as the conjunction between selections.
#     Default: "and"
#   all      - [string] (optional) Only applicable if multiple is enabled.
#     Text to display for the select all option.
#   none     - [string] (optional) Only applicable if multiple is enabled.
#     Text to display for the select none option.
#   empty    - [string] (optional) What to display when no options are selected.
#     Default: "none" (this is only used if multiple is specified)
#   required - [boolean] (optional) Simulates the required attribute
angular.module('pt.nlForm.select', [])
.directive('nlSelect', ->
  # allow multiple options to be selected
  checkForMultiple = (scope, element, attributes) ->
    scope.multiple = not angular.isUndefined(attributes.multiple)

    # text for the view when multiple options are selected
    isMultiple = scope.multiple and attributes.multiple isnt ''
    scope.conjunction = if isMultiple then attributes.multiple else 'and'

    # convert the value to an array if this is a multi-select
    if isMultiple
      scope.value = [] if angular.isUndefined(scope.value)
      scope.value = [ scope.value ] unless angular.isArray(scope.value)

    # an option which is the equivalent of "select all" (multiple only)
    unless angular.isUndefined(attributes.all)
      scope.allOptions = attributes.all
    else
      scope.allOptions = false

  return {
    restrict: 'EA'
    replace: true
    scope: {
      value: '='
      options: '='
    }
    controller: 'NLSelectController'
    templateUrl: 'directives/nlForm/select.html'
    link: (scope, element, attributes) ->
      # is this required
      scope.required = not angular.isUndefined(attributes.required)

      # text for the view when no options are selected
      unless angular.isUndefined(attributes.none)
        scope.none = attributes.none
      else
        scope.none = 'none'

      checkForMultiple(scope, element, attributes)
      return
  }
).controller 'NLSelectController', [
  '$scope'
  ($scope) ->
    # option list type constants
    # e.g. [ 'one', 'two', 'three', ...]
    ARRAY_OF_LABELS = 1
    # e.g. [ { label: 'one', value: 'ten'}, { label: 'two', value: 'nine'}, ...]
    ARRAY_OF_OBJECTS = 2
    # e.g. { 'one':'ten', 'two':'nine', 'three':'eight', ...}
    OBJECT_OF_VALUES = 3
    # e.g. { 'one':{ label: 'one', value: 'ten'},
    #         'two':{ label: 'two', value: 'nine' }, ...}
    OBJECT_OF_OBJECTS = 4

    # is the value in the list of options
    isOption = (value) ->
      found = false
      angular.forEach $scope.options, (opt) ->
        switch $scope.optionType
          when ARRAY_OF_LABELS, OBJECT_OF_VALUES
            found = true if value is opt
          when ARRAY_OF_OBJECTS, OBJECT_OF_OBJECTS
            found = true if value is opt.value
        return
      found

    optionsLength = ->
      switch $scope.optionType
        when ARRAY_OF_LABELS, ARRAY_OF_OBJECTS
          return $scope.options.length
        when OBJECT_OF_OBJECTS, OBJECT_OF_VALUES
          ctr = 0
          angular.forEach $scope.options, ->
            ctr = ctr + 1
          return ctr
      0

    # get the option at the given index, normalized as an object:
    # { value: 'value', label: 'label' }
    getOption = (index) ->
      if 0 <= index < optionsLength()
        switch $scope.optionType
          when ARRAY_OF_LABELS
            # the label and value are the same
            return {
              value: $scope.options[0]
              label: $scope.options[0]
            }
          when ARRAY_OF_OBJECTS
            # already normalized
            return $scope.options[0]
          when OBJECT_OF_VALUES, OBJECT_OF_OBJECTS
            # iterate through the options to find the index
            option = null
            ctr = 0
            angular.forEach $scope.options, (value, label) ->
              if ctr is index
                if $scope.optionType is OBJECT_OF_VALUES
                  option = {
                    value: value
                    label: label
                  }
                else
                  option = value
              ctr = ctr + 1
              return
            return option
      {
        value: ''
        label: ''
      }

    # get the label from the given value
    getLabel = (value) ->
      label = value
      switch $scope.optionType
        when ARRAY_OF_OBJECTS, OBJECT_OF_OBJECTS
          # find the option with the given value and get its value
          angular.forEach $scope.options, (opt) ->
            label = opt.label if opt.value is value
        when ARRAY_OF_LABELS
          # the label is the value so don't do anything
          return
        when OBJECT_OF_VALUES
          # find the option with the given value and get the index (the label)
          angular.forEach $scope.options, (opt, index) ->
            label = index if value is opt
      label

    # get the value given the label
    getValue = (label) ->
      value = label
      switch $scope.optionType
        when ARRAY_OF_LABELS
          # the value is the label so don't do anything
          return
        when ARRAY_OF_OBJECTS
          # find the option with the given label and get its value
          angular.forEach $scope.options, (opt) ->
            value = opt.value if opt.label is label
        when OBJECT_OF_VALUES
          # simple index retrieval
          value = $scope.options[label]
        when OBJECT_OF_OBJECTS
          # simple index retrieval
          value = $scope.options[label].value
      value

    # given an option (label, object, value, etc) retrieve its label
    getLabelFromOption = (option) ->
      label = option
      switch $scope.optionType
        when ARRAY_OF_LABELS
          # the option is the value so don't do anything
          return
        when OBJECT_OF_VALUES
          angular.forEach $scope.options, (val, lbl) ->
            label = lbl if option is val
        when ARRAY_OF_OBJECTS
          # find the option with the given label
          angular.forEach $scope.options, (opt) ->
            label = opt.label if opt.value is option.value
        when OBJECT_OF_OBJECTS
          angular.forEach $scope.options, (val, lbl) ->
            label = lbl if option is val
      label

    # check to make sure all the values are in the list of options
    checkValue = ->
      if $scope.multiple
        values = []
        angular.forEach $scope.value, (value) ->
          values.push(value) if isOption(value)
        $scope.value = values
      else
        $scope.value = getOption(0).value unless isOption($scope.value)

    # is the select open
    $scope.opened = false

    # has the input been blurred
    $scope.touched = false

    # open the select
    $scope.open = (event) ->
      event.stopPropagation()
      $scope.opened = true

    # close the select
    $scope.close = ->
      $scope.opened = false
      $scope.touched = true

    # select an option
    $scope.select = (option) ->
      $scope.setValue option
      $scope.close()

    # select all options
    $scope.selectAll = ->
      angular.forEach $scope.options, (option) ->
        label = getLabelFromOption(option)
        $scope.select(label) unless $scope.isSelected(label)
        $scope.close()

    # unselect all options
    $scope.selectNone = ->
      angular.forEach $scope.options, (option) ->
        label = getLabelFromOption(option)
        $scope.select(label) if $scope.isSelected(label)
        $scope.close()

    ###*
    # Returns true if all possible options have been selected; false otherwise.
    # @returns {boolean}
    ###
    $scope.isAllSelected = ->
      not angular.isUndefined($scope.value) and
      $scope.value.length is optionsLength()

    ###*
    # Returns true if no options are selected; false otherwise.
    # @returns {boolean}
    ###
    $scope.isNoneSelected = ->
      angular.isUndefined($scope.value) or $scope.value.length is 0

    # set the value, or add it to the list if this is a multi-select
    $scope.setValue = (option) ->
      value = getValue(option)
      if $scope.multiple
        index = $scope.value.indexOf(value)
        if index is -1
          $scope.value.push value
        else
          $scope.value.splice index, 1
        if $scope.required
          # at least one option must be selected
          if $scope.value.length is 0
            # no options selected so it's invalid
            $scope.nlSelect.$setValidity 'required', false
          else
            # we're good here
            $scope.nlSelect.$setValidity 'required', true
      else
        $scope.value = value
      return

    # extract just the labels from the options
    $scope.getLabels = ->
      switch $scope.optionType
        when ARRAY_OF_LABELS
          # don't need to do anything
          return $scope.options
        when ARRAY_OF_OBJECTS
          # map the array to pull out the label
          return $scope.options.map((opt) -> opt.label)
        when OBJECT_OF_VALUES, OBJECT_OF_OBJECTS
          # iterate through the options to get the labels
          options = []
          angular.forEach $scope.options, (value, label) ->
            if $scope.optionType is OBJECT_OF_VALUES
              options.push label
            else
              options.push value.label
            return
          return options
      []

    # concatenate the current selections for the view
    $scope.getSelected = ->
      if $scope.multiple
        # there might be multiple selections
        text = ''
        if not angular.isUndefined($scope.value) and $scope.value.length > 0
          # there is at least one selection
          if $scope.allOptions and $scope.value.length is optionsLength()
            # all options are selected and the 'all' parameter is set
            text = $scope.allOptions
          else
            comma = ''
            ctr = 1
            angular.forEach $scope.value, (value) ->
              text += comma + getLabel(value)
              ctr = ctr + 1
              if $scope.value.length > 2
                comma = ', '
              else
                comma = ' '
              if ctr is $scope.value.length
                comma += $scope.conjunction + ' '
              return
        else
          # no selections
          text = $scope.none
        text
      else
        # only one selection possible
        getLabel $scope.value

    # check if the option is selected
    $scope.isSelected = (option) ->
      return false if angular.isUndefined($scope.value)
      if $scope.multiple
        $scope.value.indexOf(getValue(option)) > -1
      else
        $scope.value is getValue(option)

    # make sure we update the options internally if they change externally
    $scope.$watch 'options', (->
      # reset option list type
      $scope.optionType = null
      if angular.isArray($scope.options) # option list is an array
        if angular.isObject($scope.options[0]) # of objects
          $scope.optionType = ARRAY_OF_OBJECTS
        else # of labels
          $scope.optionType = ARRAY_OF_LABELS
      else if angular.isObject($scope.options) # option list is an object
        for key of $scope.options
          if $scope.options.hasOwnProperty(key)
            if angular.isObject($scope.options[key]) # of objects
              $scope.optionType = OBJECT_OF_OBJECTS
            else # of key:value pairs
              $scope.optionType = OBJECT_OF_VALUES
            break
      # make sure the value is still in the list of options
      checkValue()
      return
    ), true
    return
]
