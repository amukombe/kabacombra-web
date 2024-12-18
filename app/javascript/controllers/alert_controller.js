import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="alert"
export default class extends Controller {
  static targets = ["alertDialog"]
  connect() {
    //console.log("Alert clicked");
  }

  closeAlert(event) {
    event.preventDefault();
    const target  = this.alertDialogTarget;
    target.classList.add("hidden");
     // Remove the alert frdialongom the DOM
  }
}
