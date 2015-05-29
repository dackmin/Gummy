'use strict'

###*
 # @ngdoc function
 # @name gummyApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the gummyApp
###
angular.module 'gummyApp'
    .controller 'MainCtrl', ($scope, $trakt, $rotten) ->


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
         # Handle file drop
         # @method drop
         # @param {Array} files - Droped files
        ###
        $scope.drop = (files) ->

            for file in files

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
                        $scope.grid.push data[0]
                    .catch (e) ->
                        console.error e


        # Add event to document
        document.addEventListener "dragover", (e) -> e.preventDefault() and e.stopPropagation()
        document.addEventListener "dragleave", (e) -> e.preventDefault() and e.stopPropagation()
        document.addEventListener "drop", (e) ->
            e.preventDefault()
            e.stopPropagation()
            $scope.drop e.dataTransfer.files
