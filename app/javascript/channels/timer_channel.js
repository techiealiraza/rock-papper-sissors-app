import consumer from "./consumer"

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
    const imageUrls = [
      "/assets/rock.png",
      "/assets/paper.png",
      "/assets/scissor.png",
      "/assets/rock.png",
      "/assets/paper.png",
      "/assets/rock.png",
      "/assets/scissor.png",
    ];
    var seconds = data
    const displayDiv = document.getElementById("second_timer");
    displayDiv.textContent = seconds;
    const random_img = document.getElementById(2)
    const user_image = document.getElementById(1)
    if(data != 'Stop'){
      var currentImageIndex = Math.ceil(Math.random() * 6)
      random_img.src = imageUrls[currentImageIndex];
    }
    if(data === 5)
    {
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

    if(data === 'Stop'){
      var imageElement = document.getElementById(1);
    var src = imageElement.src;
    var fileName = src.substring(src.lastIndexOf('/') + 1);
      console.log(fileName)
      disable_button("rock_button")
      disable_button("paper_button")
      disable_button("scissor_button")
      
      // channel.perform('greet', {name: 'John'}, function(response) {
      //   console.log(response);
      // });
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
  }
});
})
