import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "message"]
  static values = {
    formId: String,
    message: String
  }

  connect() {
    console.log("✅ confirm modal")
  }

  show(event) {
    event.stopPropagation();
    const trigger = event.currentTarget;
  
    const message = trigger.dataset.confirmModalMessageValue || "Are you sure?"
    const formId = trigger.dataset.confirmModalFormIdValue
  
    this.messageTarget.textContent = message
    this.modalTarget.classList.remove("hidden")
  
    // Store formId for use in confirm()
    this._formId = formId
  }
  
  confirm() {
    const form = document.getElementById(this._formId)
    if (form) form.submit()
    this.modalTarget.classList.add("hidden")
  }
  

  cancel() {
    this.modalTarget.classList.add("hidden")
  }

}
