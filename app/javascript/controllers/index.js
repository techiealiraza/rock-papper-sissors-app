import { Application } from "stimulus";
import { definitionsFromContext } from "stimulus/webpack-helpers";

const application = Application.start();
const context = require.context("controllers", true, /_controller\.js$/);
application.load(definitionsFromContext(context));

import CountdownController from "./countdown_controller";
application.register("countdown", CountdownController);

import PassController from "./pass_controller";
application.register("pass", PassController);

import ChoiceController from "./choice_controller";
application.register("choice", ChoiceController);
