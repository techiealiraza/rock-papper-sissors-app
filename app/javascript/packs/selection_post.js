import Rails from "@rails/ujs";
function selectionPost() {
  const user1Element = document.getElementById("player1_id");
  const user2Element = document.getElementById("player2_id");
  const currentUserElement = document.getElementById("user_id");

  const player1Id = user1Element.getAttribute("data-player1-id");
  const player2Id = user2Element.getAttribute("data-player2-id");
  const currentUserId = currentUserElement.getAttribute("data-user-id");
  const matchElement = document.getElementById("match_id");
  const tournamentElement = document.getElementById("tournament_id");
  const matchId = matchElement.getAttribute("data-match-id");
  const tournamentId = tournamentElement.getAttribute("data-tournament-id");
  if ([player1Id, player2Id].includes(currentUserId)) {
    const imageElement = document.getElementById(currentUserId);
    var src = imageElement.src;
    var fileName = src.substring(src.lastIndexOf("/") + 1);
    const userSelectedChoice = fileName.substring(0, fileName.lastIndexOf("."));
    if (fileName[0] == "q") {
      return;
    }
    var data = {
      match_id: matchId,
      user_id: currentUserId,
      choice: userSelectedChoice,
    };
    Rails.ajax({
      url: `/tournaments/${tournamentId}/matches/${matchId}/selection`,
      type: 'post',
      beforeSend(xhr, options) {
        xhr.setRequestHeader('Content-Type', 'application/json; charset=UTF-8')
        options.data = JSON.stringify(data)
        return true
      },
    });
  }
}

export { selectionPost };
