'use strict'

###*
 # @ngdoc function
 # @name gummyApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the gummyApp
###
angular
    .module 'gummyApp'
    .controller 'HeaderCtrl', ($scope) ->

        $scope.focused = true

        $scope.close = () ->
            console.log "lol"
            window.close()

        window.onblur = (e) ->
            $scope.focused = false
            $scope.$apply()

        window.onfocus = (e) ->
            $scope.focused = true
            $scope.$apply()
