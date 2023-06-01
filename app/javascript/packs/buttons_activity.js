function event_listener_to_buttons() {
  const user1Element = document.getElementById("player1_id");
  const user2Element = document.getElementById("player2_id");
  const user = document.getElementById("user_id");

  const player1_id = user1Element.getAttribute("data-player1-id");
  const player2_id = user2Element.getAttribute("data-player2-id");
  const user_id = user.getAttribute("data-user-id");
  var user_image;
  var flag = false;

  if (player1_id === user_id) {
    user_image = document.getElementById(player1_id);
    flag = true;
  } else if (player2_id === user_id) {
    user_image = document.getElementById(player2_id);
    flag = true;
  }
  if (flag) {
    document
      .getElementById("rock_button")
      .addEventListener("click", function () {
        user_image.src = "/assets/rock.png";
      });
    document
      .getElementById("paper_button")
      .addEventListener("click", function () {
        user_image.src = "/assets/paper.png";
      });
    document
      .getElementById("scissor_button")
      .addEventListener("click", function () {
        user_image.src = "/assets/scissor.png";
      });
    enable_button("rock_button");
    enable_button("paper_button");
    enable_button("scissor_button");
  }
}
function disable_buttons() {
  disable_button("rock_button");
  disable_button("paper_button");
  disable_button("scissor_button");
}
function enable_buttons() {
  enable_button("rock_button");
  enable_button("paper_button");
  enable_button("scissor_button");
}
function disable_button(id) {
  document.getElementById(id).disabled = true;
  document.getElementById(id).classList.remove("choice-button");
  document.getElementById(id).classList.add("choice-button2");
}
function enable_button(id) {
  document.getElementById(id).disabled = false;
  document.getElementById(id).classList.remove("choice-button");
  document.getElementById(id).classList.add("choice-button2");
}

export { event_listener_to_buttons, disable_buttons };
