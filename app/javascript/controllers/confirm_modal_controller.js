import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "message"]
  static values = {
    formId: String,
    message: String
  }
  
  connect() {
    console.log("ConfirmModalController connected!")
    this.form = null
    this._ensureEvents()
  }
  
  _ensureEvents() {
    this.element.querySelectorAll('[data-action~="click->confirm-modal#show"]').forEach(button => {
      button.addEventListener("click", this.show.bind(this))
    })
  }
  
  show(event) {
    event.preventDefault();
  
    console.log("Delete button clicked");
  
    // Store form reference
    this.form = document.getElementById(this.formIdValue);
    console.log("Form reference:", this.form);
  
    this.messageTarget.textContent = this.messageValue || "Are you sure?";
    this.modalTarget.classList.remove("hidden");
  }

  cancel() {
    this.modalTarget.classList.add("hidden")
    this.form = null
  }

  confirm() {
    if (this.form) {
      this.form.requestSubmit()
    }
    this.cancel()
  }
}
