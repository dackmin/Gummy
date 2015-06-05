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
    .controller 'GetInfosCtrl', ($scope, $rootScope, $trakt, $db, $timeout) ->


        ###*
         # Movie model
         # @attribute movie
        ###
        $scope.movie = $rootScope.seeking.movie


        ###*
         # Found movies list
         # @attribute movies
        ###
        $scope.movies = []


        ###*
         # Current seeked filename
         # @attribute filename
        ###
        $scope.filename = ""


        ###*
         # Currently loading
         # @attribute loading
        ###
        $scope.loading =
            list: false


        ###*
         # Current errors
         # @attribute errors
        ###
        $scope.errors = []


        ###*
         # Close seeked movie
         # @method close
        ###
        $scope.close = () ->
            $timeout () ->
                $rootScope.seeking = null


        ###*
         # Init controller
         # @method init
        ###
        $scope.init = () ->

            # Get filename from movie previous added file
            full_path = $scope.movie.path.split "/"
            full_filename = full_path.pop().split "."
            ext = full_filename.pop()
            $scope.movie.filename = $scope.filename = full_filename.join " "

            $scope.seek()


        ###*
         # Seek a movie list from a filename search
         # @method seek
        ###
        $scope.seek = () ->
            $scope.errors = []
            $scope.movies = []
            $scope.loading.list = true

            # Call provider for infos
            $trakt
                .search $scope.filename
                .then (data) ->
                    $scope.movies = data
                .catch (e) ->
                    $scope.errors.push e
                .finally () ->
                    $scope.loading.list = false


        ###*
         # Update saved movie infos with found one
         # @method chose
         # @param {Object} movie
        ###
        $scope.chose = (movie) ->

            # Sanitize
            _tmp = angular.copy movie
            _tmp.path = $scope.movie.path

            # Update movie to db
            $db.movies.update { path: $scope.movie.path }, _tmp, {}, (e, items) ->
                if e then console.error "MovieUpdate", e
                else if items <= 0 then console.error "MovieUpdate", "Nothing updated"
                else
                    $rootScope.seeking.movie = _tmp
                    $scope.close()


        # GOGO GADGETO SEEKING
        $scope.init()
