import consumer from "./consumer"
import { random_image, event_listener_to_buttons, disable_buttons, enable_buttons } from '../packs/buttons_activity';
import { try_post } from '../packs/try_post';

document.addEventListener('turbolinks:load', () => {
  const element = document.getElementById('match_id');
  const userElement = document.getElementById('user_id');
  const match_id = element.getAttribute('data-match-id');
  const user_id = userElement.getAttribute('data-user-id');
  consumer.subscriptions.create({channel: "TimerChannel", match_id: match_id},  {
  connected() {
    // debugger
    console.log(`Connected to timer ${match_id}`);
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    console.log("Disconnected from Timer Channel")
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    if(data.id1 != undefined){
      let id1 = data.id1
      let id2 = data.id2
      let selection1 = data.selection1
      let selection2 = data.selection2
      let status1 = data.status1
      let status2 = data.status2
      const user_selection = document.getElementById(1)
      const opponent_selection = document.getElementById(2)
      const displayDiv = document.getElementById("second_timer")
      if(parseInt(user_id) == id1){
        user_selection.src = "/assets/"+selection1+".png"
        opponent_selection.src = "/assets/"+selection2+".png"
        displayDiv.textContent = status1;
      }
      else if(parseInt(user_id) == id2){
        user_selection.src = "/assets/"+selection2+".png"
        opponent_selection.src = "/assets/"+selection1+".png"
        displayDiv.textContent = status2;
      }
    }
    else{
      let seconds = data.seconds
      let try_num = data.try_num
      let tries = data.tries
      const displayDiv = document.getElementById("second_timer");
      const triesDiv = document.getElementById(`tries_${match_id}`);
      displayDiv.textContent = seconds;
      if(seconds != 0){
        triesDiv.textContent = `Try ${try_num} of ${tries}`;
        if(seconds === 5)
        {
          event_listener_to_buttons()
          const user_selection = document.getElementById(1)
          const opponent_selection = document.getElementById(2)
          user_selection.src = "/assets/question.png"
          opponent_selection.src = "/assets/question.png"
        }
      }
      else{
        disable_buttons()
        try_post()
      }
    }
  }
});
})
