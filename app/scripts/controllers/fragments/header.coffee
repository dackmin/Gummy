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

        $scope.remote = require "remote"

        $scope.focused = true

        $scope.close = () ->
            $scope.remote.getCurrentWindow().close()


        $scope.minimize = () ->
            $scope.remote.getCurrentWindow().minimize()

        window.onblur = (e) ->
            $scope.focused = false
            $scope.$apply()

        window.onfocus = (e) ->
            $scope.focused = true

            if $scope.remote.getCurrentWindow().isClosed()
                $scope.remote.getCurrentWindow().restart()
            $scope.$apply()
