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
    .controller 'EditInfosCtrl', ($scope, $rootScope, $db, $timeout) ->


        # Imports
        remote = require "remote"
        dialog = remote.require "dialog"


        ###*
         # Old infos
         # @attribute infos
        ###
        $scope.old_movie = $rootScope.editing.movie


        ###*
         # Movie model
         # @attribute movie
        ###
        $scope.movie = angular.copy $scope.old_movie


        ###*
         # Currently loading
         # @attribute loading
        ###
        $scope.loading =
            update: false


        ###*
         # Help user find a file in its computer
         # @method find_file
        ###
        $scope.find_file = ->
            dialog.showOpenDialog remote.getCurrentWindow(), { properties: ["openFile"] }, (files) ->
                if files.length > 0
                    $timeout () ->
                        $scope.movie.path = files[0]


        ###*
         # Close edited movie
         # @method close
        ###
        $scope.close = () ->
            $timeout () ->
                $rootScope.editing = null


        ###*
         # Update saved movie infos with found one
         # @method chose
         # @param {Object} movie
        ###
        $scope.update = () ->
            $scope.loading.update = true

            # Update movie to db
            $db.movies.update { path: $scope.old_movie.path }, $scope.movie, {}, (e, items) ->
                if e then console.error "MovieUpdate", e
                else if items <= 0 then console.error "MovieUpdate", "Nothing updated"
                else
                    $rootScope.seeking.movie = $scope.movie
                    $scope.close()

                $scope.loading.update = true
