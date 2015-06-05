'use strict'

###*
 # @ngdoc function
 # @name gummyApp.controller:EditInfosCtrl
 # @description
 # # EditInfosCtrl
 # Controller of the gummyApp
###
angular
    .module 'gummyApp'
    .controller 'EditInfosCtrl', ($scope, $rootScope, $timeout) ->


        ###*
         # Movie model
         # @attribute movie
        ###
        $scope.movie = $rootScope.editing.movie


        ###*
         # Close edited movie
         # @method close
        ###
        $scope.close = () ->
            $timeout () ->
                $rootScope.editing = null
