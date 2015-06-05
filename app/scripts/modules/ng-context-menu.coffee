"use strict"

remote = require "remote"
win = remote.getCurrentWindow()
dialog = remote.require "dialog"
Menu = remote.require "menu"

angular
    .module "ng-context-menu", []

    .directive "ngContextMenu", ->
        restrict: "A"
        replace: false
        link: (scope, $elmt, $attrs) ->

            # Create context menu
            scope.contextmenu = Menu.buildFromTemplate [
                {
                    label: "Get informations for this movie..."
                    click: ->
                        scope.$parent.seek_movie_infos scope
                }
                {
                    type: "separator"
                }
                {
                    label: "Show"
                    click: ->
                        scope.$parent.open_movie scope.movie
                }
                {
                    label: "Delete"
                    click: ->
                        choice = dialog.showMessageBox
                            type: "info"
                            buttons: ["Yes", "No"]
                            title: "Delete movie"
                            message: "Do you really want to remove #{scope.movie.title} ?"

                        if choice is 0 then scope.$parent.delete_movie scope
                }
                {
                    label: "Properties"
                    click: ->
                        scope.$parent.edit_movie scope
                }
            ]

            # Open context menu on right click
            $elmt.on "contextmenu", (e) =>
                scope.contextmenu.popup remote.getCurrentWindow()
