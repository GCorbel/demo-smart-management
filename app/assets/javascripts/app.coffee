app = angular.module('management', ['smart-table', 'restangular'])

app.factory('RestManager', =>
  class RestManager
    @editableColumns = =>
      $("[ng-app='#{app.name}']").first().data('editable-columns').split(',')

    @visibleColumns = =>
      $("[ng-app='#{app.name}']").first().data('visible-columns').split(',')

    @pluralModelName = =>
      $("[ng-app='#{app.name}']").first().data('plural-model-name')

    @singularModelName = =>
      $("[ng-app='#{app.name}']").first().data('singular-model-name')
)

app.config ["RestangularProvider", (RestangularProvider) ->
  RestangularProvider.addResponseInterceptor (data, operation) ->
    extractedData = undefined
    if operation == 'getList'
      extractedData = data.items
      extractedData.meta = data.meta
    else
      extractedData = data.data

    extractedData
]

app.controller "sortCtrl", [
  "$scope"
  "$filter"
  "Restangular"
  "RestManager"
  (scope, filter, Restangular, RestManager) ->
    Restangular.setRequestSuffix('.json')

    scope.callServer = (tableState) ->
      console.log tableState
      scope.rowCollection = []
      Restangular.all(RestManager.pluralModelName()).getList(tableState).then (resources) ->
        tableState.pagination.numberOfPages = Math.ceil(resources.meta.total / tableState.pagination.number)
        $.each resources, (_, resource) ->
          addNewRow(resource)

    scope.showEdit = (row) ->
      scope.editedRow = row
      scope.editedResource = row.resource.clone()

      openFormModal('edit')
      return

    scope.showNew = ->
      scope.editedResource = {}
      $.each RestManager.editableColumns(), (column) ->
        scope.editedResource[column] = ''

      openFormModal('new')
      return

    scope.submitEntry = ->
      if scope.editedResource["id"]
        scope.editedResource.put().then( (resource) ->
          scope.editedRow.resource = resource
          $('#formModal').modal('hide')
        , (result) ->
          showErrors result
        )
      else
        options = {}
        options[RestManager.singularModelName()] = scope.editedResource

        Restangular.all(RestManager.pluralModelName())
        .post(options).then((resource) ->
          addNewRow(resource)
          $('#formModal').modal('hide')
        , (result) ->
          showErrors result
        )


    scope.deleteEntry = (row) ->
      row.resource.remove().then ->
        scope.rowCollection = _.filter(scope.rowCollection, (item) ->
          item != row
        )

    openFormModal = (mode) ->
      $('#formModal').modal()
      $('#formModal form').removeAttr('action')
      if mode == 'edit'
        $('#formModalLabel').html("Edit #{scope.editedResource.id}")
      else
        $('#formModalLabel').html('Add a new')

    addNewRow = (resource) ->
      row = {}
      row.resource = resource
      row.editUrl = "/#{RestManager.pluralModelName}/#{resource.id}"
      scope.rowCollection.push(row)

    showErrors = (result) ->
      alert $.map(result.data.errors, (messages, fieldName) ->
        "#{fieldName} : #{messages.join()}"
      ).join('\n')
]

app.directive "managerRow", ->
  replace: true
  template: $('#row').text()
