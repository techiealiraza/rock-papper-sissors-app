import { Application } from "stimulus";
import { definitionsFromContext } from "stimulus/webpack-helpers";

const application = Application.start();
const context = require.context("controllers", true, /_controller\.js$/);
application.load(definitionsFromContext(context));

import CountdownController from "./countdown_controller";
application.register("countdown", CountdownController);

import LoadController from "./load_controller"
application.register("load", LoadController)