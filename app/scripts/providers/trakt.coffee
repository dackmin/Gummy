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


            
