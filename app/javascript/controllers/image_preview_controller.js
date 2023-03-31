import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="image-preview"
export default class extends Controller {
  load() {
    const [file] = imgInp.files
  if (file) {
    imgId.src = URL.createObjectURL(file)
  }
}
}
