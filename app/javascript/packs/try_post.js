function try_post() {
  const user1Element = document.getElementById("player1_id");
  const user2Element = document.getElementById("player2_id");
  const user = document.getElementById("user_id");

  const player1_id = user1Element.getAttribute("data-player1-id");
  const player2_id = user2Element.getAttribute("data-player2-id");
  const user_id = user.getAttribute("data-user-id");
  const match_element = document.getElementById("match_id");
  const match_id = match_element.getAttribute("data-match-id");
  if (player1_id == user_id || player2_id == user_id ) {
    const imageElement = document.getElementById(user_id);
    var src = imageElement.src;
    var fileName = src.substring(src.lastIndexOf("/") + 1);
    const user_selection_image = fileName.substring(0, fileName.lastIndexOf("."));
    if (fileName[0] == "q") {
      return;
    }
    var data = {
      selection: {
        match_id: match_id,
        user_id: user_id,
        selection: user_selection_image,
      },
    };
    var xhr = new XMLHttpRequest();
    xhr.open("POST", "/selection", true);
    xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    var csrf_token = document.getElementsByName("csrf-token")[0].content;
    xhr.setRequestHeader("X-CSRF-Token", csrf_token);
    xhr.onreadystatechange = function () {
      if (xhr.readyState === XMLHttpRequest.DONE) {
        if (xhr.status === 200 || xhr.status === 201) {
          var response = JSON.parse(xhr.responseText);
          console.log(response.data);
        } else if (xhr.status === 422) {
          console.error("Error:", xhr.responseText);
        } else {
          console.error("Error:", xhr.responseText);
        }
      }
    };
  }
  if (data != undefined && data != "string") {
    xhr.send(JSON.stringify(data));
  }
}

export { try_post };
