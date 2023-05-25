import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import "./buttons_activity";
import "./try_post";
import "channels";
import "../css/application.scss";
import "../controllers/countdown_controller";
import "../packs/navigation.js";
import "../packs/flash_loadfile_script.js";

Rails.start();
Turbolinks.start();
ActiveStorage.start();

import "controllers";
