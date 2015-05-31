'use strict'

###*
 # @ngdoc function
 # @name gummyApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the gummyApp
###
remote = require "remote"
app = remote.require("app")
Datastore = remote.require "nedb"

angular.module 'gummyApp'
    .controller 'MainCtrl', ($scope, $rootScope, $timeout, $trakt, $rotten) ->


        ###*
         # Internal database
         # @attribute db
        ###
        $scope.db = new Datastore
            filename: "#{app.getPath 'home'}/Gummy/movies.db"
            autoload: true


        ###*
         # Handled files types
         # @attribute allowed
        ###
        $scope.allowed = [
            "mkv"
            "mpeg"
            "mpg"
            "mp4"
            "mov"
            "avi"
        ]


        ###*
         # Movie grid
         # @attribute grid
        ###
        $scope.grid = []


        ###*
         # Init app
         # @method init
        ###
        $scope.init = () ->


            # Add drop event to document
            document.addEventListener "dragover", (e) -> e.preventDefault() and e.stopPropagation()
            document.addEventListener "dragleave", (e) -> e.preventDefault() and e.stopPropagation()
            document.addEventListener "drop", (e) ->
                e.preventDefault()
                e.stopPropagation()
                $scope.drop e.dataTransfer.files


            # Read DB
            $scope.db.find {}, (e, movies) ->
                if e then console.error e

                # Add existing movies to main grid
                for movie in movies
                    $scope.add_movie movie




        ###*
         # Open movie details
         # @method open_movie
         # @param {Object} movie
        ###
        $scope.open_movie = (movie) ->
            $trakt
                .get movie.id, movie
                .then (data) ->
                    $rootScope.selected = data
                .catch (e) ->
                    console.error e


        ###*
         # Handle file drop
         # @method drop
         # @param {Array} files - Droped files
        ###
        $scope.drop = (files) ->

            for file in files

                console.log file

                # Check for ext
                filename = file.name.split(".")
                ext = filename.pop()
                if $scope.allowed.indexOf(ext) is -1
                    return

                # Rejoin filename parts with a space (previously replaced all
                # dots in name)
                filename = filename.join " "

                # Find movie infos
                $trakt
                    .search filename
                    .then (data) ->

                        # Add filepath to db
                        movie = data[0]
                        movie.path = file.path

                        # Save data to DB
                        $scope.db.insert movie, (e, item) ->
                            if e then return console.error e

                            # Add data to main grid
                            $scope.add_movie movie


                    .catch (e) ->
                        console.error e


        ###*
         # Add a movie and getting rid of angular fucking digest cycle
        ###
        $scope.add_movie = (movie) ->
            $timeout () ->
                $scope.grid.push movie



        #$scope.check = (filepath) ->

        # Init app
        $scope.init()
