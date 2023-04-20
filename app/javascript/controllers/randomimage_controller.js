import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
//   static values = { id: String };
  
  imageUrls = [
    "/assets/rock.png",
    "/assets/paper.png",
    "/assets/scissor.png",
    "/assets/rock.png",
    "/assets/paper.png",
    "/assets/rock.png",
    "/assets/scissor.png",

  ];

  interval = 100;
  currentImageIndex = 0;

  connect() {
    const matchId = this.element.dataset.matchId;
    // document.getElementById(1).src = "/assets/question.png";
    // console.log(">>>>>>>>>>>>>>>>>>")
    // console.log(`User_id:: ${matchId}`)
    // console.log(">>>>>>>>>>>>>>>>>>")
  
    this.changeImage();
    // debugger

  }
  

  changeImage() {
    var id = this.element.dataset.id
    const imageContainer = document.getElementById(2);
    if (imageContainer) {
      imageContainer.src = this.imageUrls[this.currentImageIndex];
      this.currentImageIndex = Math.ceil(Math.random() * 6);
      var first_image = this.choiceName(1).split('.')[0]
      var second_image = this.choiceName(2).split('.')[0]
      // console.log(`${first_image} ${second_image}`)
      // const userId = this.element.dataset.userId;
      
      document.getElementById('rock_button').addEventListener('click', function() {
          var user_image = document.getElementById(1)
          user_image.src = "/assets/rock.png";
        });
        document.getElementById('paper_button').addEventListener('click', function() {
          var user_image = document.getElementById(1)
          user_image.src = "/assets/paper.png";
        });
        document.getElementById('scissor_button').addEventListener('click', function() {
          var user_image = document.getElementById(1)
          user_image.src = "/assets/scissor.png";
        });
          
    }
    var timerDivValue = document.getElementById("second_div").textContent
    if (timerDivValue != "Stop"){
        setTimeout(() => this.changeImage(), this.interval);
    }
    else{
    
      disable_button("rock_button")
      disable_button("paper_button")
      disable_button("scissor_button")
        let user = this.element.dataset.userId
        let match_id = this.element.dataset.matchId
        if (user != 'x') {
          // console.log(">>>>0>>>>")
          match_id = parseInt(match_id)
          user = parseInt(user)
          if (first_image[0] == 'q'){
            const imageContainer = document.getElementById(1);
            this.currentImageIndex = Math.ceil(Math.random() * 6)
            imageContainer.src = this.imageUrls[this.currentImageIndex];
            var first_image = this.choiceName(1).split('.')[0]
          }
          // console.log(">>>>......>>>>")
          // console.log(typeof first_image)
          // console.log(">>>>.......>>>>")
          var data = {
            selection: {
                match_id: match_id,
                user: user,
                selection: first_image,
            }
        };
        }

          
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "/selection", true);
        xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        var csrf_token = document.getElementsByName("csrf-token")[0].content;
        xhr.setRequestHeader("X-CSRF-Token", csrf_token); 
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
              if (xhr.status === 200 || xhr.status === 201) {
                // Handle the successful response
                var response = JSON.parse(xhr.responseText);
                console.log(response.data);
              } else if (xhr.status === 422) {
                // Handle the error response
                console.error("Error:", xhr.responseText);
              } else {
                // Handle other error cases
                console.error("Error:", xhr.responseText);
              }
            }
        };
        if (data != undefined && data != "string") {
        // xhr.send(JSON.stringify(data));
        }
        
    }
    function disable_button(id){
      document.getElementById(id).disabled = true;
      document.getElementById(id).classList.remove('choice-button')
      document.getElementById(id).classList.add('choice-button2')
    }
  }
  choiceName(id){
    var imageElement = document.getElementById(id);
    var src = imageElement.src;
    var fileName = src.substring(src.lastIndexOf('/') + 1);
    return fileName;
  }

}
