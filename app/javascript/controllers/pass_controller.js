import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="pass"
export default class extends Controller {
  static targets = ["unhide"];
  password() {
    console.log("password");
  }
  otp() {
    console.log("text");
  }
}
