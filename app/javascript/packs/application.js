import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import "./buttons_activity";
import "./selection_post";
import "channels";
import "../css/application.scss";
import "../controllers/countdown_controller";
import "./navigation.js";
import "./flash.js";

Rails.start();
Turbolinks.start();
ActiveStorage.start();

import "controllers";
