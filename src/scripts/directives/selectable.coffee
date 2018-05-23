(->

  class SelectableDirective
    constructor: ($document) ->
      return {
        restrict: 'E'
        templateUrl: 'directives/selectable.html'
        replace: true
        scope: {
          placeholder: '@',
          inputClass: '@',
          ngModel: '=',
          options: '='
          valueField: '@'
          multi: '@'
        }
        link: (scope, element, attrs) ->

          scope.init = ->
            scope.valueField = scope.valueField or 'value'
            scope.open = false
            scope.setAll()

            # if options are object, convert to array
            if {}.toString.call(scope.options) is '[object Object]'
              options_arr = []
              for k, v of scope.options
                options_arr.push {
                  id: k,
                  value: v
                }
              scope.options = options_arr

          scope.toggleOpen = ->
            scope.open = not scope.open

          scope.setAll = ->
            if scope.multi
              scope.ngModel = []
              scope.ngModelSet = new Set()
            else
              scope.ngModel = ''

          scope.setSelected = (option) ->
            if scope.multi
              if (scope.ngModelSet.has(option.id))
                scope.ngModelSet.delete(option.id)
              else
                scope.ngModelSet.add(option.id)
              scope.ngModel = Array.from scope.ngModelSet
            else
              scope.ngModel = option.id
              scope.open = false

          scope.checkboxOnOff = (option) ->
            if scope.multi
              scope.ngModelSet.has(option.id)
            else
              scope.ngModel is option.id

          scope.title = ->
            if scope.multi
              if scope.ngModelSet.size
                result = []
                result_arr = Array.from scope.ngModelSet
                _.each result_arr, (item) ->
                  option = _.find scope.options, (option) ->
                    option.id is item
                  result.push option[scope.valueField]
                result.join  ', '
              else
                scope.placeholder
            else
              option = _.find scope.options, (option) ->
                option.id is scope.ngModel
              if option
                option[scope.valueField]
              else
                scope.placeholder

          scope.init()

          $dropdownTrigger = element[0]
          $document.click (e) ->
            target = e.target
            parentFound = false

            while angular.isDefined(target) and
                  target isnt null and
                  not parentFound

              parentFound = true if target is $dropdownTrigger
              target = target.parentElement

            if not parentFound
              scope.$apply ->
                scope.open = false
       }



  angular
    .module('appForm')
    .directive('selectable', ['$document', SelectableDirective])

)()
