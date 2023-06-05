import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect = (format = "seconds") => {
    const reg_date = this.data.get("time");
    const time_in_seconds = reg_date;
    const daysElement = document.getElementById("days");
    const hoursElement = document.getElementById("hours");
    const minutesElement = document.getElementById("minutes");
    const secondsElement = document.getElementById("seconds");
    let countdown;
    console.log(time_in_seconds);
    if (time_in_seconds < 0) {
      clearDivs();
      return;
    }
    convertFormat(format);
    function convertFormat(format) {
      switch (format) {
        case "seconds":
          return timer(time_in_seconds);
        case "minutes":
          return timer(time_in_seconds * 60);
        case "hours":
          return timer(time_in_seconds * 60 * 60);
        case "days":
          return timer(time_in_seconds * 60 * 60 * 24);
      }
    }

    function timer(seconds) {
      const now = Date.now();
      const then = now + seconds * 1000;

      countdown = setInterval(() => {
        const secondsLeft = Math.round((then - Date.now()) / 1000);

        if (secondsLeft <= 0) {
          clearDivs();
          clearInterval(countdown);
          location.reload;
          return;
        }

        displayTimeLeft(secondsLeft);
      }, 1000);
    }
    function clearDivs() {
      daysElement.style.display = "none";
      hoursElement.style.display = "none";
      minutesElement.style.display = "none";
      secondsElement.style.display = "none";
    }
    function displayTimeLeft(seconds) {
      daysElement.textContent = Math.floor(seconds / 86400);
      hoursElement.textContent = Math.floor((seconds % 86400) / 3600);
      minutesElement.textContent = Math.floor(((seconds % 86400) % 3600) / 60);
      secondsElement.textContent =
        seconds % 60 < 10 ? `0${seconds % 60}` : seconds % 60;
    }
  };
}
