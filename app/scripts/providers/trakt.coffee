'use strict'

###*
 # @ngdoc function
 # @name gummyApp.provider:$trakt
 # @description
 # # $trakt
 # Trakt TV API provider
###
angular
    .module 'gummyApp'
    .service '$trakt', ($http, $q) ->


        ###*
         # Api method
         # @attribute API_METHOD
        ###
        @API_METHOD = "https://"


        ###*
         # Api root url
         # @attribute API_ROOT
        ###
        @API_ROOT = "api-v2launch.trakt.tv"


        ###*
         # API custom headers
         # @attribute HEADERS
        ###
        @HEADERS =
            "Content-Type": "application/json"
            "trakt-api-key": "6a858663eb2b89454c785ce93981f7726b90f33169ac454004d33d8837c4d0e8"
            "trakt-api-version": "2"


        ###*
         # Find a movie
         # @method search
         # @param {String} name - Movie name
        ###
        @search = (name) ->
            q = $q.defer()

            $http
                method: "GET"
                url: "#{@API_METHOD}#{@API_ROOT}/search"
                params:
                    query: name
                    type: "movie"
                headers: @HEADERS
            .success (data) =>
                movies = []
                movies.push @toSimpleJSON(obj) for key, obj of data
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
            q = $q.defer()

            # Get cast members
            @cast id
            .then (cast) =>

                # Compile raw data
                raw =
                    infos: infos
                    cast: cast

                # Return parsed data
                q.resolve @toJSON(raw)

            .catch (e) ->
                q.reject e

            q.promise


        ###*
         # Get cast members
         # @method cast
         # @param {String|int} id - Movie slug/id
         # @return {Object} - $q promise
        ###
        @cast = (id) ->
            q = $q.defer()

            $http
                method: "GET"
                url: "#{@API_METHOD}#{@API_ROOT}/movies/#{id}/people"
                headers: @HEADERS
            .success (data) ->
                cast = []
                cast.push item.person.name for item in data.cast
                q.resolve cast
            .error (e) ->
                q.reject e

            q.promise


        ###*
         # Return movie as simple json object
         # @method toSimpleJSON
         # @param {Object} raw - Raw data from movie
         # @return {Object} - simply parsed json object
        ###
        @toSimpleJSON = (raw) ->
            id: raw.movie.ids.slug
            rating: raw.score
            title: raw.movie.title
            synopsis: raw.movie.overview
            year: raw.movie.year
            cover:
                small: raw.movie.images.poster.thumb
                medium: raw.movie.images.poster.medium
                large: raw.movie.images.poster.full
            raw: raw


        ###*
         # Return movie as a normal json object
         # @method toJSON
         # @param {Object} raw - Raw movie data
         # @return {Object} - parsed json object
        ###
        @toJSON = (raw) ->
            console.log raw

            id: raw.infos.raw.movie.ids.slug
            rating: raw.infos.raw.movie.rating * 10
            title: raw.infos.raw.movie.title
            synopsis: raw.infos.raw.movie.overview
            year: raw.infos.raw.movie.year
            cast: raw.cast.slice(0, 3).join ", "
            cover:
                small: raw.infos.raw.movie.images.poster.thumb
                medium: raw.infos.raw.movie.images.poster.medium
                large: raw.infos.raw.movie.images.poster.full

        @
