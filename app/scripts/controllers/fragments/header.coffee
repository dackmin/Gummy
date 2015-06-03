'use strict'

remote = require "remote"

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


        ###*
         # Get current operating system
         # @attribute system
        ###
        $scope.system =
            darwin: false #/^darwin/.test process.platform
            windows: true #/^win/.test process.platform
            linux: /^linux/.test process.platform


        ###*
         # Whether window is focused or not
         # @attribute focused
        ###
        $scope.focused = true


        ###*
         # Close app
         # @method close
        ###
        $scope.close = () ->
            remote.getCurrentWindow().close()


        ###*
         # Minimize app
         # @method minimize
        ###
        $scope.minimize = () ->
            remote.getCurrentWindow().minimize()


        # Add events to current window
        window.onblur = (e) ->
            $scope.focused = false
            $scope.$apply()

        window.onfocus = (e) ->
            $scope.focused = true

            if remote.getCurrentWindow().isClosed()
                remote.getCurrentWindow().restart()
            $scope.$apply()
