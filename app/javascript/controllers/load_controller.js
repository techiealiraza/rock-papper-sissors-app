import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    var loadFile = function (event) {
      var output = document.getElementById("output");
      output.src = URL.createObjectURL(event.target.files[0]);
      output.onload = function () {
        URL.revokeObjectURL(output.src);
      };
    };
    loadFile(event);
  }
}
