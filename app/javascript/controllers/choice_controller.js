import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    timer;
    // tournament_id
    countDown(i, callback) {
        if(i < 0) {
            // return
        }
        this.timer = setInterval(() => {
            // let minutes = parseInt(i / 60, 10);
            let seconds = i;
            // console.log(seconds)
            const d = document;
            const secondsElement = d.getElementById('second_div');
            if (seconds>0){
              secondsElement.textContent = seconds;
            }
            else
            {
              secondsElement.textContent = "Stop";
              return;
            }

            i-- || (clearInterval(this.timer), callback());
        }, 1000);
    }

    connect() {
        const  element = document.getElementById('second_timer');
        // debugger
        
        const timeInterval = parseInt(element.getAttribute('data-timer-id'));
        this.countDown(timeInterval, () => {
            // Make sure you have imported jQuery library before using it
            // document.getElementById('choice').style.display = 'block';
        });
    }
}

