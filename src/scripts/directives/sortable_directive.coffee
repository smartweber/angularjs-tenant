'use strict'

angular.module('appForm').directive 'sortable', [
  '$document', ($document) ->
    {
      restrict: 'A'
      scope: {
        sortable: '='
      }
      link: (scope, element, attrs) ->
        scope.sortable ||= {}
        columns = element.find('[sortable-column]')

        update = ->
          columns.each (index, column) ->
            column = $(column)
            columnName = column.attr 'sortable-column'
            icon = column.find('.icon')
            icon.removeClass 'sorting sorting-asc sorting-desc'
            if scope.sortable.column is columnName
              column.addClass 'text-blue'
              if scope.sortable.order is 'ascending'
                icon.addClass 'sorting-asc'
              else
                icon.addClass 'sorting-desc'
            else
              column.removeClass 'text-blue'
              icon.addClass 'sorting'

        columnOnClick = (event) ->
          columnElement = $(event.target).closest '[sortable-column]'
          column = columnElement.attr 'sortable-column'
          scope.$apply ->
            if scope.sortable.column isnt column
              scope.sortable.column = column
              scope.sortable.order = 'descending'
            else
              if scope.sortable.order is 'ascending'
                scope.sortable.order = 'descending'
              else
                scope.sortable.order = 'ascending'
          update()

        columns.on 'click', columnOnClick
        update()
    }
]
