import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect = (format = "seconds") => {
    const reg_date = this.data.get("time");
    const tournament_id = this.data.get("id");
    const number = reg_date;
    const daysElement = document.getElementById("days");
    const hoursElement = document.getElementById("hours");
    const minutesElement = document.getElementById("minutes");
    const secondsElement = document.getElementById("seconds");
    let countdown;
    convertFormat(format);
    function convertFormat(format) {
      switch (format) {
        case "seconds":
          return timer(number);
        case "minutes":
          return timer(number * 60);
        case "hours":
          return timer(number * 60 * 60);
        case "days":
          return timer(number * 60 * 60 * 24);
      }
    }

    function timer(seconds) {
      const now = Date.now();
      const then = now + seconds * 1000;

      countdown = setInterval(() => {
        const secondsLeft = Math.round((then - Date.now()) / 1000);

        if (secondsLeft <= 0) {
          document.getElementById("days").style.display = "none";
          document.getElementById("hours").style.display = "none";
          document.getElementById("minutes").style.display = "none";
          document.getElementById("seconds").style.display = "none";
          clearInterval(countdown);
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
  };
}
