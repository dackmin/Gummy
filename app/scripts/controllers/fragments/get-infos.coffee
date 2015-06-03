'use strict'

###*
 # @ngdoc function
 # @name gummyApp.controller:GetInfosCtrl
 # @description
 # # GetInfosCtrl
 # Controller of the gummyApp
###
angular
    .module 'gummyApp'
    .controller 'GetInfosCtrl', ($scope, $rootScope, $trakt, $db) ->


        ###*
         # Movie model
         # @attribute movie
        ###
        $scope.movie = $rootScope.seeking


        ###*
         # Found movies list
         # @attribute movies
        ###
        $scope.movies = []


        ###*
         # Close seeked movie
         # @method close
        ###
        $scope.close = () ->
            $rootScope.seeking = null


        ###*
         # Seek a movie list from a filename search
         # @method seek
        ###
        $scope.seek = () ->

            # Get filename from movie previous added file
            full_path = $scope.movie.path.split "/"
            full_filename = full_path.pop().split "."
            ext = full_filename.pop()
            filename = $scope.movie.filename = filename = full_filename.join " "

            # Call provider for infos
            $trakt
                .search filename
                .then (data) ->
                    $scope.movies = data


        ###*
         # Update saved movie infos with found one
         # @method chose
         # @param {Object} movie
        ###
        $scope.chose = (movie) ->

            # Sanitize
            _tmp = angular.copy movie
            delete _tmp.$$hashkey
            _tmp.path = $scope.movie.path

            # Update movie to db
            $db.movies.update { path: $scope.movie.path }, _tmp, {}, (e, items) ->
                if e then console.error "MovieUpdate", e
                else if items <= 0 then console.error "MovieUpdate", "Nothing updated"
                else $rootScope.$emit "refresh.movies", {}


        # GOGO GADGETO SEEKING
        $scope.seek()
