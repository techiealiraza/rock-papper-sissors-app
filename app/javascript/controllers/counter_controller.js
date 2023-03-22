import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="counter"
export default class extends Controller {
  connect() {
    console.log("Connecting to data-controller=")
  }
}
