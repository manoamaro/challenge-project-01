# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

angular.module 'searchModule', []
  .controller 'SearchCtrl', ['$http', '$log', '$q', ($http, $log, $q) ->
    @searchTextChange = (searchText) ->
      $log.info 'Text change ' + searchText
      return
    @selectedItemChange = (item) ->
      $log.info 'Selected Item Changed'
      return
    @querySearch = (searchText) ->
      $log.info 'Query Search ' + searchText
      return $http.get('/search').then((response) ->
        return response.data
      )
    return
    ]
