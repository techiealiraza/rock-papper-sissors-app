import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	timer;
	countDown(i, callback) {
		if (i < 0) {
		}
		this.timer = setInterval(() => {
			let seconds = i;
			const d = document;
			const secondsElement = d.getElementById("second_div");
			if (seconds > 0) {
				secondsElement.textContent = seconds;
			} else {
				secondsElement.textContent = "Stop";
				return;
			}

			i-- || (clearInterval(this.timer), callback());
		}, 1000);
	}

	connect() {
		const element = document.getElementById("second_timer");
		const timeInterval = parseInt(element.getAttribute("data-timer-id"));
		this.countDown(timeInterval, () => {});
	}
}
