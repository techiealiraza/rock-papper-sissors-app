import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { id: String };
  
  imageUrls = [
    "/assets/rock.png",
    "/assets/scissor.png",
    "/assets/paper.png",
    "/assets/rock.png",
    "/assets/paper.png",
    "/assets/rock.png",
    "/assets/scissor.png",

  ];

  interval = 0;
  currentImageIndex = 0;

  connect() {
    this.changeImage();
  }

  changeImage() {
    var id = this.element.dataset.id
    const imageContainer = document.getElementById(id);
    if (imageContainer) {
      imageContainer.src = this.imageUrls[this.currentImageIndex];
      this.currentImageIndex = Math.ceil(Math.random() * 6);

    }
    var timerDivValue = document.getElementById("second").textContent
    if (timerDivValue != "Stop"){

    setTimeout(() => this.changeImage(), this.interval);
    }
  }

}
