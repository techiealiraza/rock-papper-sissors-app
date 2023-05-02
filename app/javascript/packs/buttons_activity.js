function random_image(){
    const imageUrls = [
        "/assets/rock.png",
        "/assets/paper.png",
        "/assets/scissor.png",
        "/assets/rock.png",
        "/assets/paper.png",
        "/assets/rock.png",
        "/assets/scissor.png",
      ];
    const random_img = document.getElementById(2)
    var currentImageIndex = Math.ceil(Math.random() * 6)
    random_img.src = imageUrls[currentImageIndex];
}
function event_listener_to_buttons(){
    const user_image = document.getElementById(1)
    document.getElementById('rock_button').addEventListener('click', function() {
        user_image.src = "/assets/rock.png";
      });
      document.getElementById('paper_button').addEventListener('click', function() {
        user_image.src = "/assets/paper.png";
      });
      document.getElementById('scissor_button').addEventListener('click', function() {
        user_image.src = "/assets/scissor.png";
      });
      enable_button("rock_button")
      enable_button("paper_button")
      enable_button("scissor_button")
}
function disable_buttons(){
    disable_button("rock_button")
    disable_button("paper_button")
    disable_button("scissor_button")
}
function enable_buttons(){
    enable_button("rock_button")
    enable_button("paper_button")
    enable_button("scissor_button")
}
function disable_button(id){
    document.getElementById(id).disabled = true;
    document.getElementById(id).classList.remove('choice-button')
    document.getElementById(id).classList.add('choice-button2')
}
function enable_button(id){
    document.getElementById(id).disabled = false;
    document.getElementById(id).classList.remove('choice-button')
    document.getElementById(id).classList.add('choice-button2')
}

export { random_image, event_listener_to_buttons, disable_buttons, enable_buttons };
