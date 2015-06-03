'use strict'

remote = require "remote"
app = remote.require "app"
Datastore = remote.require "nedb"

###*
 # @ngdoc function
 # @name gummyApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the gummyApp
###
angular.module 'gummyApp'
    .controller 'MainCtrl', ($scope, $rootScope, $timeout, $q, $trakt, $rotten) ->


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
                if e then console.error "DB", e

                # Add existing movies to main grid
                for movie in movies
                    $scope.add_movie movie


        ###*
         # Open movie details
         # @method open_movie
         # @param {Object} movie
        ###
        $scope.open_movie = (movie, apply) ->
            $rootScope.selected = movie
            if apply then $rootScope.$apply()


        ###*
         # Handle file drop
         # @method drop
         # @param {Array} files - Droped files
        ###
        $scope.drop = (files) ->

            for _file in files

                # Check if movie is already in user's library
                $scope
                    .check_filepath _file
                    .then (file) ->

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

                                # Use firts found movie by default
                                stuff = data[0]

                                # Get cast infos
                                $trakt
                                    .get stuff.id, stuff
                                    .then (movie) ->

                                        # Add filepath to db
                                        movie.path = file.path

                                        # Save data to DB
                                        $scope.db.insert movie, (e, item) ->
                                            if e then return console.error "DB", e

                                            # Add data to main grid
                                            $scope.add_movie movie

                                    .catch (e) ->
                                        console.error "API", e

                            .catch (e) ->
                                console.error "API", e

                    .catch (e) ->
                        console.warn "Check_Movie", e


        ###*
         # Add a movie and getting rid of angular fucking digest cycle
         # @method add_movie
         # @param {Object} movie - Your movie object
        ###
        $scope.add_movie = (movie) ->
            $timeout () ->
                $scope.grid.push movie


        ###*
         # Check if movie already exists in db (based on filepath)
         # @method check_movie
         # @param {String} filepath - Wanted filename
         # @return {Object} - $q promise
        ###
        $scope.check_filepath = (file) ->
            q = $q.defer()

            $scope.db.find { path: file.path }, (e, items) ->
                if e then q.reject e
                else if items.length > 0 then q.reject "Movie already in library"
                else q.resolve file

            q.promise


        # Init app
        $scope.init()
