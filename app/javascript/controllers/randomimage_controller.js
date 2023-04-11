import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { id: String };
  
  imageUrls = [
    "/assets/rock.png",
    "/assets/scissor.png",
    "/assets/paper.png",
    "/assets/question.png",
    "/assets/paper.png",
    "/assets/rock.png",
    "/assets/question.png",

  ];

  interval = 500;
  currentImageIndex = 0;

  connect() {
//   id = this.element.dataset.id;
console.log("????????????????????")
  console.log(this.element.dataset.id)
console.log("????????????????????")

    this.changeImage();
  }

  changeImage() {
    var id = this.element.dataset.id
    const imageContainer = document.getElementById(id);
    if (imageContainer) {
      imageContainer.src = this.imageUrls[this.currentImageIndex];
      this.currentImageIndex = Math.ceil(Math.random() * 6);
    }
    setTimeout(() => this.changeImage(), this.interval);
  }

}
