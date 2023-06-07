import Rails from "@rails/ujs";
function try_post() {
  const user1Element = document.getElementById("player1_id");
  const user2Element = document.getElementById("player2_id");
  const user = document.getElementById("user_id");

  const player1_id = user1Element.getAttribute("data-player1-id");
  const player2_id = user2Element.getAttribute("data-player2-id");
  const user_id = user.getAttribute("data-user-id");
  const match_element = document.getElementById("match_id");
  const match_id = match_element.getAttribute("data-match-id");
  if ([player1_id, player2_id].includes(user_id)) {
    const imageElement = document.getElementById(user_id);
    var src = imageElement.src;
    var fileName = src.substring(src.lastIndexOf("/") + 1);
    const user_selection_image = fileName.substring(0, fileName.lastIndexOf("."));
    if (fileName[0] == "q") {
      return;
    }
    var data = {
      match_id: match_id,
      user_id: user_id,
      choice: user_selection_image,
    };
    Rails.ajax({
      url: '/selection',
      type: 'post',
      beforeSend(xhr, options) {
        xhr.setRequestHeader('Content-Type', 'application/json; charset=UTF-8')
        options.data = JSON.stringify(data)
        return true
      },
    });
  }
}

export { try_post };
