import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	static targets = ["unhide"];
	password() {
		console.log("password");
	}
	otp() {
		console.log("text");
	}
}
