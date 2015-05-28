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

        $scope.movies = [
            "Batman - The Dark Knight"
            "21 Jump Street"
            "Pirates of the caribbean 3"
        ]

        $scope.grid = []

        for movie in $scope.movies
            $trakt
                .search movie
                .then (data) ->
                    console.log data
                    $scope.grid.push data[0]
                .catch (e) ->
                    console.error e
