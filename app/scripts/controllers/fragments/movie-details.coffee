'use strict'

###*
 # @ngdoc function
 # @name gummyApp.controller:MovieDetailsCtrl
 # @description
 # # MovieDetailsCtrl
 # Controller of the gummyApp
###
angular.module 'gummyApp'
    .controller 'MovieDetailsCtrl', ($scope, $rootScope) ->


        ###*
         # Movie model
         # @attribute movie
        ###
        $scope.movie = $rootScope.selected


        ###*
         # Close selected movie
         # @method close
        ###
        $scope.close = () ->
            $rootScope.selected = null
