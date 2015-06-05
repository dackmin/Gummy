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
    .controller 'MainCtrl', ($scope, $rootScope, $timeout, $q, $trakt, $db, $location) ->

        # Imports
        remote = require "remote"
        app = remote.require "app"


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
        $scope.init = ->
            $scope.reset_movies()

            # Read DB
            $db.movies
                .find {}
                .sort
                    title: 1
                .exec (e, movies) ->
                    if e then console.error "DB", e

                    # Add existing movies to main grid
                    for movie in movies
                        $scope.add_movie movie


        ###*
         # Open movie details
         # @method open_movie
         # @param {Object} movie
        ###
        $scope.open_movie = (movie) ->
            $timeout ->
                $rootScope.selected = movie


        ###*
         # Seek more infos on a precise movie
         # @method seek_movie_infos
         # @param {Object} movie
        ###
        $scope.seek_movie_infos = (movie) ->
            $timeout ->
                $rootScope.seeking = movie


        ###*
         # Edit a movie, lol
         # @method edit_movie
         # @param {Object} movie
        ###
        $scope.edit_movie = (movie) ->
            $timeout ->
                $rootScope.editing = movie


        ###*
         # Remove a movie from library
         # @method delete_movie
         # @param {Object} item - Scope from movie item
        ###
        $scope.delete_movie = (item) ->
            console.log item
            $db.movies
                .remove { path: item.movie.path }, {}, (e, removed) ->
                    if e then console.error "RemoveMovie", e
                    else if removed is 0 then console.error "RemoveMovie", "Nothing has been removed"
                    else
                        $timeout ->
                            $scope.grid.splice $scope.grid.indexOf(item.movie), 1


        ###*
         # Handle file drop
         # @method drop
         # @param {Array} files - Droped files
        ###
        $scope.drop = (files) ->

            if(files.length > 20)
                return alert "For now, Gummy is uber-shitty and cannot handle more than 20 movies-drop at a time"

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

                        # Rejoin filename parts with a space (previously
                        # replaced all dots in name)
                        filename = filename.join " "

                        # Find movie infos
                        $trakt
                            .search filename
                            .then (data) ->

                                # If nothing is found, we add an empty movie for
                                # future seek
                                if data.length == 0
                                    $scope.insert_movie $trakt.toEmpty(filename, file.path)

                                else
                                    # Use firts found movie by default
                                    stuff = data[0]

                                    # Get cast infos
                                    $trakt
                                        .get stuff.id, stuff
                                        .then (movie) ->

                                            # Add filepath to db
                                            movie.path = file.path

                                            # Add data to main grid
                                            $scope.insert_movie movie

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
         # Insert a new movie to db
         # @method insert_movie
         # @param {Object} movie - Your movie
        ###
        $scope.insert_movie = (movie) ->
            $db.movies.insert movie, (e, item) ->
                if e then console.error "[AddMovie]", e
                else $scope.add_movie movie

        ###*
         # Refresh grid with stream from db
         # @method reset_movies
        ###
        $scope.reset_movies = ->
            $timeout ->
                $scope.grid = []


        ###*
         # Check if movie already exists in db (based on filepath)
         # @method check_movie
         # @param {String} filepath - Wanted filename
         # @return {Object} - $q promise
        ###
        $scope.check_filepath = (file) ->
            q = $q.defer()

            $db.movies.find { path: file.path }, (e, items) ->
                if e then q.reject e
                else if items.length > 0 then q.reject "Movie already in library"
                else q.resolve file

            q.promise


        # Add drop event to document
        document.addEventListener "dragover", (e) -> e.preventDefault() and e.stopPropagation()
        document.addEventListener "dragleave", (e) -> e.preventDefault() and e.stopPropagation()
        document.addEventListener "drop", (e) ->
            e.preventDefault()
            e.stopPropagation()
            $scope.drop e.dataTransfer.files

        # Init app
        $scope.init()
