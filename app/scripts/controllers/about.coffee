'use strict'

###*
 # @ngdoc function
 # @name gummyApp.controller:AboutCtrl
 # @description
 # # AboutCtrl
 # Controller of the gummyApp
###
angular.module 'gummyApp'
  .controller 'AboutCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
