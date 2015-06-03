'use strict'

remote = require "remote"
BrowserWindow = remote.getCurrentWindow()

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
            darwin: /^darwin/.test process.platform
            windows: /^win/.test process.platform
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


        ###*
         # Maximize app
         # @method maximize
        ###
        $scope.maximize = () ->
            if $scope.system.darwin
                BrowserWindow.setKiosk !BrowserWindow.isKiosk()
            else
                if BrowserWindow.isMaximized() then BrowserWindow.maximize() else BrowserWindow.unmaximize()


        # Add events to current window
        window.onblur = (e) ->
            $scope.focused = false
            $scope.$apply()

        window.onfocus = (e) ->
            $scope.focused = true

            if remote.getCurrentWindow().isClosed()
                remote.getCurrentWindow().restart()
            $scope.$apply()
