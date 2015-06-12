'use strict'

###*
 # @ngdoc function
 # @name gummyApp.provider:$rotten
 # @description
 # # $trakt
 # Rotten Tomatoes API provider
###
angular
    .module 'gummyApp'
    .service '$rotten', ($http, $q) ->


        ###*
         # Api method
         # @attribute API_METHOD
        ###
        @API_METHOD = "http://"


        ###*
         # Api root url
         # @attribute API_ROOT
        ###
        @API_ROOT = "api.rottentomatoes.com/api/public/v1.0"


        ###*
         # Find a movie
         # @method search
         # @param {String} name - Movie name
        ###
        @search = (name) ->
            q = $q.defer()

            $http
                method: "GET"
                url: "#{@API_METHOD}#{@API_ROOT}/movies.json"
                params:
                    q: name
                    api_key: "n3ppab9xdhpnq5udzn3f7wxt"
            .success (data) ->
                movies = []
                movies.push @toSimpleJSON(obj) for obj in data.movies
                q.resolve movies
            .error (e) ->
                q.reject e

            q.promise


        ###*
         # Get movie infos
         # @method get
         # @param {String|int} id - Movie id/slug
         # @param {Object} infos - Additional infos
         # @return {Object} - $q promise
        ###
        @get = (id, infos) ->
            infos.cast = @cast infos.raw.abridged_cast
            @toJSON infos.raw


        ###*
         # Get cast members
         # @method cast
         # @param {String|int} id - Movie slug/id
         # @return {Object} - $q promise
        ###
        @cast = (raw) ->
            cast = []
            cast.push person.name for person in raw
            cast


        ###*
         # Return movie as simple json object
         # @method toSimpleJSON
         # @param {Object} raw - Raw data from movie
         # @return {Object} - simply parsed json object
        ###
        @toSimpleJSON = (raw) ->
            id: raw.id
            rating: raw.ratings.audience_score
            title: raw.title
            synopsis: raw.synopsis
            year: raw.year
            cover:
                small: raw.posters.thumbnail
                medium: raw.posters.detailed
                large: raw.posters.original
            background:
                small: ""
                medium: ""
                large: ""
            raw: raw


        ###*
         # Return movie as a normal json object
         # @method toJSON
         # @param {Object} raw - Raw movie data
         # @return {Object} - parsed json object
        ###
        @toJSON = (raw) ->
            id: raw.id
            rating: raw.ratings.audience_score
            title: raw.title
            synopsis: raw.synopsis
            year: raw.year
            cast: raw.cast
            cover:
                small: raw.posters.thumbnail
                medium: raw.posters.detailed
                large: raw.posters.original
            background:
                small: ""
                medium: ""
                large: ""


        ###*
         # Generate an empty object when movie is not recognized
         # @method toEmpty
         # @param {String} filename - Sanitized filename (the.best.movie.ever.720p.HDTV.mkv becomes "The best movie ever")
         # @param {String} path - original filepath
         # @return {Object}
        ###
        @toEmpty = (filename, path) ->
            id: ""
            rating: 0
            title: filename
            path: path
            synopsis: ""
            year: (new Date()).getFullYear()
            cover:
                small: ""
                medium: ""
                large: ""
            background:
                small: ""
                medium: ""
                large: ""
            raw: {}


        @
