import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    const timeInSeconds = this.data.get("time");
    const daysElement = document.getElementById("days");
    const hoursElement = document.getElementById("hours");
    const minutesElement = document.getElementById("minutes");
    const secondsElement = document.getElementById("seconds");
    let countdown;
    return countdownRefreshTimer(timeInSeconds);
    function countdownRefreshTimer(seconds) {
      const then = Date.now() + seconds * 1000;
      countdown = setInterval(() => {
        const secondsLeft = Math.round((then - Date.now()) / 1000);
        if (secondsLeft <= 0) {
          location.reload(true);
          return;
        }
        displayTimeLeft(secondsLeft);
      }, 1000);
    }
    function displayTimeLeft(seconds) {
      daysElement.textContent = Math.floor(seconds / 86400);
      hoursElement.textContent = Math.floor((seconds % 86400) / 3600);
      minutesElement.textContent = Math.floor(((seconds % 86400) % 3600) / 60);
      secondsElement.textContent =
        seconds % 60 < 10 ? `0${seconds % 60}` : seconds % 60;
    }
  }
}
