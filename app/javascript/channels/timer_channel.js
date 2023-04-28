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
    var seconds = data
    const displayDiv = document.getElementById("second_timer");
    displayDiv.textContent = seconds;
    if(data != 'Stop'){
      random_image();
    }
    if(data === 5)
    {
      event_listener_to_buttons()
    }

    if(data === 'Stop'){
    // var imageElement = document.getElementById(1);
    // var src = imageElement.src;
    // var fileName = src.substring(src.lastIndexOf('/') + 1);
    // console.log(fileName)
    disable_buttons()
    // disable_button("rock_button")
    // disable_button("paper_button")
    // disable_button("scissor_button")
      
      // channel.perform('greet', {name: 'John'}, function(response) {
      //   console.log(response);
      // });
      try_post()
    }
  }
});
})
