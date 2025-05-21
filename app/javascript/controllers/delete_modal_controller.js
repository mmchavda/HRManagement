// app/javascript/controllers/delete_modal_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["modal", "message", "confirm"];

  connect() {
    this.expenseId = null;
  }

  open(event) {
    event.preventDefault();
    this.modelId = event.currentTarget.dataset.modelId;
    const message = event.currentTarget.dataset.modelMessage;

    // this.messageTarget.textContent = message || "Are you sure?";
    this.modalTarget.classList.remove("hidden");
  }

  confirm() {
    if (this.modelId) {
      const form = document.getElementById(`delete-form-${this.modelId}`);
      if (form) {
        form.querySelector('input[type="submit"]').click();
      }
      this.close();
    }
  }

  close() {
    this.modalTarget.classList.add("hidden");
  }
}
