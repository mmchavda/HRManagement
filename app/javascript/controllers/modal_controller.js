// app/javascript/controllers/modal_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["background"]
  connect() {
    this.element.classList.remove("hidden")
  }

  close(e) {
    if (e.target === this.element || e.target.dataset.action === "modal#close") {
      this.element.classList.add("hidden")
    }
  }
}
