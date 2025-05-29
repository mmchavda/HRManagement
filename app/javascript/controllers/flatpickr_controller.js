// app/javascript/controllers/flatpickr_controller.js
import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"

export default class extends Controller {
  connect() {
    flatpickr(this.element, {
      enableTime: false,
      allowInput: this.allowInputValue ?? true,
      dateFormat: "Y-m-d"
    })
  }
}
