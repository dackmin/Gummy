'use strict'

###*
 # @ngdoc overview
 # @name gummyApp
 # @description
 # # gummyApp
 #
 # Main module of the application.
###
angular
  .module 'gummyApp', [
    'ngAnimate'
    'ngCookies'
    'ngMessages'
    'ngResource'
    'ngRoute'
    'ngSanitize'
    'ngTouch'
    'ng-context-menu'
  ]
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .when '/about',
        templateUrl: 'views/about.html'
        controller: 'AboutCtrl'
      .otherwise
        redirectTo: '/'
