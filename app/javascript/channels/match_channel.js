import consumer from "./consumer";
import {
  eventListenerToButtons,
  disableButtons,
} from "../packs/buttons_activity";
import { selectionPost } from "../packs/selection_post";

document.addEventListener("turbolinks:load", () => {
  const matchId = document.getElementById("match_id").getAttribute("data-match-id");
  consumer.subscriptions.create(
    { channel: "MatchChannel", match_id: matchId },
    {
      received(data) {
        const player1Id = document.getElementById("player1_id").getAttribute("data-player1-id");
        const player2Id = document.getElementById("player2_id").getAttribute("data-player2-id");
        const userId = document.getElementById("user_id").getAttribute("data-user-id");
        if (data.user1_id != undefined) {
          var choice1 = data.choice1;
          var choice2 = data.choice2;
          var status = data.status;
          const user1ChoiceElement = document.getElementById(data.user1_id);
          const user2ChoiceElement = document.getElementById(data.user2_id);
          const displayDiv = document.getElementById("second_timer");
          user1ChoiceElement.src = "/assets/" + choice1 + ".png";
          user2ChoiceElement.src = "/assets/" + choice2 + ".png";
          displayDiv.textContent = status;
          if (data.done != undefined) {
            setTimeout(function() {
              location.reload(true);
            }, 2000);
            return;
          }
          
        } else {
          var seconds = data.seconds;
          var tryNum = data.try_num;
          var tries = data.tries;
          const displayDiv = document.getElementById("second_timer");
          const triesDiv = document.getElementById(`tries_${matchId}`);
          displayDiv.textContent = seconds;
          if (seconds != 0) {
            triesDiv.textContent = `Try ${tryNum} of ${tries}`;
            if (seconds === 5) {
              eventListenerToButtons();
              const user1ChoiceElement = document.getElementById(player1Id);
              const user2ChoiceElement = document.getElementById(player2Id);
              user1ChoiceElement.src = "/assets/question.png";
              user2ChoiceElement.src = "/assets/question.png";
            }
          } else {
            disableButtons();
            if ([player1Id, player2Id].includes(userId)) {
              selectionPost();
            }
          }
        }
      },
    }
  );
});
