// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

// import { application } from "./application"

import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"
// import { application } from "./application"

const application = Application.start()
const context = require.context("controllers", true, /_controller\.js$/)
application.load(definitionsFromContext(context))

import CountdownController from "./countdown_controller"
application.register("countdown", CountdownController)

import PassController from "./pass_controller"
application.register("pass", PassController)

import ChoiceController from "./choice_controller"
application.register("choice", ChoiceController)

import RandomimageController from "./randomimage_controller"
application.register("random", RandomimageController)