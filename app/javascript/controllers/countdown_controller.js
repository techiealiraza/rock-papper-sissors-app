import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="image-preview")

export default class extends Controller {

    connect = (format = 'seconds') => {
      // let decodedCookie = decodeURIComponent(document.cookie);
      // console.log(decodedCookie)
      // const reg_date = decodedCookie
      const reg_date = this.data.get("time");
      const tournament_id = this.data.get("id");
      // console.log("/////////////////////////")
      // console.log(tournament_id);
      // console.log("////////////////////////")
      // console.log(new Date(reg_date));
      // console.log(new Date(reg_date));
      var total = Date.parse(new Date(reg_date)) - Date.parse(new Date());
      // console.log(total);
      const number = Math.floor((total / 1000)-18000);
      const d = document;
      // var className = document.getElementsByClassName();
      // for(var index=0;index < className.length;index++){
      //   console.log("VVVVVVVVVVVVVVVVVVVVVVVVVV")
      //   console.log(className[index]);
      // }
      // const tournamenElement = d.getElementById(tournament_id)
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
