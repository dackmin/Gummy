"use strict"

remote = require "remote"
Menu = remote.require "menu"

angular
    .module "ng-context-menu", []

    .directive "ngContextMenu", () ->
        restrict: "A"
        replace: false
        link: (scope, $elmt, $attrs) ->

            # Create context menu
            scope.contextmenu = Menu.buildFromTemplate [
                {
                    label: "Show",
                    click: () ->
                        scope.$parent.open_movie scope.movie, true
                }
                {
                    label: "Get informations for this movie...",
                    click: () ->
                        scope.$parent.seek_movie_infos scope, true
                }
            ]

            # Open context menu on right click
            $elmt.on "contextmenu", (e) =>
                scope.contextmenu.popup remote.getCurrentWindow()
