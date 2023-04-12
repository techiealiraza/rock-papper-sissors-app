import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
//   static values = { id: String };
  
  imageUrls = [
    "/assets/rock.png",
    "/assets/scissor.png",
    "/assets/paper.png",
    "/assets/rock.png",
    "/assets/paper.png",
    "/assets/rock.png",
    "/assets/scissor.png",

  ];

  interval = 100;
  currentImageIndex = 0;

  connect() {
    const userId = this.element.dataset.userId;
    const matchId = this.element.dataset.matchId;;
    console.log(">>>>>>>>>>>>>>>>>>")
    console.log(userId)
    console.log(matchId)
    console.log(">>>>>>>>>>>>>>>>>>")

    this.changeImage();
    // debugger

  }
  

  changeImage() {
    var id = this.element.dataset.id
    const imageContainer = document.getElementById(id);
    if (imageContainer) {
      imageContainer.src = this.imageUrls[this.currentImageIndex];
      this.currentImageIndex = Math.ceil(Math.random() * 6);
      var first_image = this.choiceName(1).split('.')[0]
      var second_image = this.choiceName(2).split('.')[0]
      console.log(`${first_image} ${second_image}`)
    }
    var timerDivValue = document.getElementById("second").textContent
    if (timerDivValue != "Stop"){
        setTimeout(() => this.changeImage(), this.interval);
    }
    else{
        var data = {
            selection: {
                match_id: 22,
                user: 18,
                selection: first_image,
            }
        };
          
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
        // xhr.send(JSON.stringify(data));
        
    }
  }
  choiceName(id){
    var imageElement = document.getElementById(id);
    var src = imageElement.src;
    var fileName = src.substring(src.lastIndexOf('/') + 1);
    return fileName;
  }

}
