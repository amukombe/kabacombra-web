import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ["input", "results"]
  connect() {
    //console.log("Search connected");
  }

  submit() {
    console.log("value captured");
    this.element.requestSubmit();
  }
}
