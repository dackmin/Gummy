'use strict'

###*
 # @ngdoc function
 # @name gummyApp.provider:$db
 # @description
 # # $db
 # Internal DB provider
###
angular
    .module 'gummyApp'
    .service '$db', ($q) ->

        # Imports
        remote = require "remote"
        app = remote.require "app"
        Datastore = remote.require "nedb"


        ###*
         # Movies db
         # @attribute movies
        ###
        @movies = new Datastore
            filename: "#{app.getPath 'home'}/Gummy/movies.db"
            autoload: true


        ###*
         # Settings db
         #
        ###
        @settings = new Datastore
            filename: "#{app.getPath 'home'}/Gummy/settings.db"
            autoload: true


        @
