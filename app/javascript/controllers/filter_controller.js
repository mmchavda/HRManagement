// app/javascript/controllers/filter_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  submit(event) {
    console.log("Filter changed! Submitting form...")

    this.element.requestSubmit()
  }
}
