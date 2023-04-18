import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    timer;
    // tournament_id
    countDown(i, callback) {
        this.timer = setInterval(() => {
            // let minutes = parseInt(i / 60, 10);
            let seconds = parseInt(i % 60, 10);
            // console.log(seconds)
            const d = document;
            const secondsElement = d.getElementById('second');
            if (seconds>0){
              secondsElement.textContent = seconds;
            }
            else
            {
              secondsElement.textContent = "Stop";
            }

            // update the persisted time interval
            localStorage.setItem('timeLeft', i);

            i-- || (clearInterval(this.timer), callback());
        }, 1000);
    }

    connect() {
        let timeInterval = 3; //time
        //check if you have the last counter value
        let timeLeft = localStorage.getItem('timeLeft');
        if (isNaN(timeLeft)) {
            //save the current interval
            localStorage.setItem('timeLeft', timeInterval);
        } else if (timeLeft == 0) {
            //save the current interval
            localStorage.setItem('timeLeft', timeInterval);
        } else {
            // take the last saved value
            timeInterval = timeLeft;
        }

        this.countDown(timeInterval, () => {
            // Make sure you have imported jQuery library before using it
            // document.getElementById('choice').style.display = 'block';
        });
    }
}
























// import { Controller } from "@hotwired/stimulus"

// // Connects to data-controller="image-preview")

// export default class extends Controller {
// timer = 0
// connect =  countDown(i, callback) => {
//     timer = setInterval(function () {
//         let minutes = parseInt(i / 60, 10);
//         let seconds = parseInt(i % 60, 10);

//         minutes = minutes < 10 ? "0" + minutes : minutes;
//         seconds = seconds < 10 ? "0" + seconds : seconds;

//         document.getElementById("displayDiv").innerHTML = "Time (h:min:sec) left for this station is  " + "0:" + minutes + ":" + seconds;

//         // update the persisted time interval
//         localStorage.setItem('timeLeft', i);

//         i-- || (clearInterval(timer), callback());

//     }, 1000);
// }

// window.onload = function () {
//     let timeInterval = 100;
//     //check if you have the last counter value
//     let timeLeft = localStorage.getItem('timeLeft');
//     if (isNaN(timeLeft)) {
//         //save the current interval
//         localStorage.setItem('timeLeft', timeInterval);
//     } else if (timeLeft == 0) {
//         //save the current interval
//         localStorage.setItem('timeLeft', timeInterval);
//     } else {
//         // take the last saved value
//         timeInterval = timeLeft;
//     }

//     countDown(timeInterval, function () {
//         $('#myModal').modal('show');
//     });
// };

    // connect = (format = 'seconds') => {
    //   const reg_date = this.data.get("time");
    //   const tournament_id = this.data.get("id");
    //   // console.log("/////////////////////////")
    //   // console.log(tournament_id);
    //   // console.log("////////////////////////")
    //   // console.log(new Date(reg_date));
    //   // console.log(new Date(reg_date));
    //   var total = Date.parse(new Date(reg_date)) - Date.parse(new Date());
    //   // console.log(total);
    //   const number = Math.floor((total / 1000)-18000);
    //   const d = document;
    //   // var className = document.getElementsByClassName();
    //   // for(var index=0;index < className.length;index++){
    //   //   console.log("VVVVVVVVVVVVVVVVVVVVVVVVVV")
    //   //   console.log(className[index]);
    //   // }
    //   // const tournamenElement = d.getElementById(tournament_id)
    //   const daysElement = d.querySelector(`[data-choice-id="${tournament_id}"] .days`);
    //   const hoursElement = d.querySelector(`[data-choice-id="${tournament_id}"] .hours`);
    //   const minutesElement = d.querySelector(`[data-choice-id="${tournament_id}"] .minutes`);
    //   const secondsElement = d.querySelector(`[data-choice-id="${tournament_id}"] .seconds`);
    //   let countdown;
    //   convertFormat(format);
    //   function convertFormat(format) {
    //     switch(format) {
    //       case 'seconds':
    //         return timer(number);
    //       case 'minutes':
    //         return timer(number * 60);
    //         case 'hours':
    //         return timer(number * 60 * 60);
    //       case 'days':
    //         return timer(number * 60 * 60 * 24);             
    //     }
    //   }
    
    //   function timer(seconds) {
    //     const now = Date.now();
    //     const then = now + seconds * 1000;
    
    //     countdown = setInterval(() => {
    //       const secondsLeft = Math.round((then - Date.now()) / 1000);
    
    //       if(secondsLeft <= 0) {
    //         document.getElementById("day").style.display = "none";
    //         document.getElementById("hour").style.display = "none";
    //         document.getElementById("minute").style.display = "none";
    //         document.getElementById("second").style.display = "none";
    //         clearInterval(countdown);
    //         return;
    //       };
    //       // console.log(secondsLeft)
    //       displayTimeLeft(secondsLeft);
    
    //     },1000);
    //   }
    // // console.lo
    //   function displayTimeLeft(seconds) {
    //     daysElement.textContent = Math.floor(seconds / 86400);
    //     hoursElement.textContent = Math.floor((seconds % 86400) / 3600);
    //     minutesElement.textContent = Math.floor((seconds % 86400) % 3600 / 60);
    //     secondsElement.textContent = seconds % 60 < 10 ? `0${seconds % 60}` : seconds % 60;
    //   } 
    // }
// }
