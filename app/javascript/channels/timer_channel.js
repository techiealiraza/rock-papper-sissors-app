import consumer from "./consumer"
import { random_image, event_listener_to_buttons, disable_buttons, enable_buttons } from '../packs/buttons_activity';
import { try_post } from '../packs/try_post';

document.addEventListener('turbolinks:load', () => {
  const element = document.getElementById('match_id');
  const match_id = element.getAttribute('data-match-id');
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
    // debugger
    var seconds = data.seconds
    var try_num = data.try_num
    const displayDiv = document.getElementById("second_timer");
    const triesDiv = document.getElementById(`tries_${match_id}`);
    displayDiv.textContent = seconds;
    if(data != 'Stop'){
      triesDiv.textContent = `Try Number: ${try_num}`;
      random_image();
    }
    if(seconds === 5)
    {
      event_listener_to_buttons()
    }

    if(seconds === 'Stop'){
      disable_buttons()
      try_post()
    }
  }
});
})
