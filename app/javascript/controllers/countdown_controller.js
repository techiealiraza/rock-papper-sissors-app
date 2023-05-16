import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

    connect = (format = 'seconds') => {
      const reg_date = this.data.get("time");
      const tournament_id = this.data.get("id");
      // var total = Date.parse(new Date(reg_date)) - Date.parse(new Date());
      const number = Math.abs(reg_date);
      console.log(number)
      const d = document;
      const daysElement = d.querySelector(`[data-countdown-id="${tournament_id}"] .days`);
      const hoursElement = d.querySelector(`[data-countdown-id="${tournament_id}"] .hours`);
      const minutesElement = d.querySelector(`[data-countdown-id="${tournament_id}"] .minutes`);
      const secondsElement = d.querySelector(`[data-countdown-id="${tournament_id}"] .seconds`);
      let countdown;
      convertFormat(format);
      function convertFormat(format) {
        switch(format) {
          case 'seconds':
            return timer(number);
          case 'minutes':
            return timer(number * 60);
            case 'hours':
            return timer(number * 60 * 60);
          case 'days':
            return timer(number * 60 * 60 * 24);             
        }
      }
    
      function timer(seconds) {
        const now = Date.now();
        const then = now + seconds * 1000;
    
        countdown = setInterval(() => {
          const secondsLeft = Math.round((then - Date.now()) / 1000);
    
          if(secondsLeft <= 0) {
            document.getElementById("days").style.display = "none";
            document.getElementById("hours").style.display = "none";
            document.getElementById("minutes").style.display = "none";
            document.getElementById("seconds").style.display = "none";
            clearInterval(countdown);
            return;
          };
    
          displayTimeLeft(secondsLeft);
    
        },1000);
      }
    
      function displayTimeLeft(seconds) {
        daysElement.textContent = Math.floor(seconds / 86400);
        hoursElement.textContent = Math.floor((seconds % 86400) / 3600);
        minutesElement.textContent = Math.floor((seconds % 86400) % 3600 / 60);
        secondsElement.textContent = seconds % 60 < 10 ? `0${seconds % 60}` : seconds % 60;
      }
    }

}
