function eventListenerToButtons() {
  const user1Element = document.getElementById("player1_id");
  const user2Element = document.getElementById("player2_id");
  const currentUserElement = document.getElementById("user_id");

  const player1Id = user1Element.getAttribute("data-player1-id");
  const player2Id = user2Element.getAttribute("data-player2-id");
  const currentUserId = currentUserElement.getAttribute("data-user-id");

  if ([player1Id, player2Id].includes(currentUserId)) {
    var userImageElement = document.getElementById(currentUserId);
    document
      .getElementById("rock_button")
      .addEventListener("click", function () {
        userImageElement.src = "/assets/rock.png";
      });
    document
      .getElementById("paper_button")
      .addEventListener("click", function () {
        userImageElement.src = "/assets/paper.png";
      });
    document
      .getElementById("scissor_button")
      .addEventListener("click", function () {
        userImageElement.src = "/assets/scissor.png";
      });
      enableButtons();
  }
}
function disableButtons() {
  disableButton("rock_button");
  disableButton("paper_button");
  disableButton("scissor_button");
}
function enableButtons() {
  enableButton("rock_button");
  enableButton("paper_button");
  enableButton("scissor_button");
}
function disableButton(id) {
  document.getElementById(id).disabled = true;
  document.getElementById(id).classList.remove("choice-button");
  document.getElementById(id).classList.add("choice-button2");
}
function enableButton(id) {
  document.getElementById(id).disabled = false;
  document.getElementById(id).classList.remove("choice-button");
  document.getElementById(id).classList.add("choice-button2");
}

export { eventListenerToButtons, disableButtons };
