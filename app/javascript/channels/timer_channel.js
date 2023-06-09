import consumer from "./consumer";
import {
  event_listener_to_buttons,
  disable_buttons,
} from "../packs/buttons_activity";
import { try_post } from "../packs/try_post";

document.addEventListener("turbolinks:load", () => {
  const element = document.getElementById("match_id");
  const user1Element = document.getElementById("player1_id");
  const user2Element = document.getElementById("player2_id");
  const playerElement = document.getElementById("player_check");
  const match_id = element.getAttribute("data-match-id");
  const player1_id = user1Element.getAttribute("data-player1-id");
  const player2_id = user2Element.getAttribute("data-player2-id");
  const is_player = playerElement.getAttribute("data-player-check");
  consumer.subscriptions.create(
    { channel: "TimerChannel", match_id: match_id },
    {
      connected() {},

      disconnected() {},

      received(data) {
        if (data.user1_id != undefined) {
          var selection1 = data.selection1;
          var selection2 = data.selection2;
          var status = data.status;
          const user1_selection = document.getElementById(player1_id);
          const user2_selection = document.getElementById(player2_id);
          const displayDiv = document.getElementById("second_timer");
          user1_selection.src = "/assets/" + selection1 + ".png";
          user2_selection.src = "/assets/" + selection2 + ".png";
          displayDiv.textContent = status;
        } else {
          var seconds = data.seconds;
          var try_num = data.try_num;
          var tries = data.tries;
          const displayDiv = document.getElementById("second_timer");
          const triesDiv = document.getElementById(`tries_${match_id}`);
          displayDiv.textContent = seconds;
          if (seconds != 0) {
            triesDiv.textContent = `Try ${try_num} of ${tries}`;
            if (seconds === 5) {
              event_listener_to_buttons();
              const user_selection = document.getElementById(player1_id);
              const opponent_selection = document.getElementById(player2_id);
              user_selection.src = "/assets/question.png";
              opponent_selection.src = "/assets/question.png";
            }
          } else {
            disable_buttons();
            if (is_player) {
              try_post();
            }
          }
        }
      },
    }
  );
});
