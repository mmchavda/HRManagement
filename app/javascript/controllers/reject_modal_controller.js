// app/javascript/controllers/reject_modal_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "ticketId", "form"]

  open(event) {
    event.preventDefault()
    const ticketId = event.currentTarget.dataset.ticketId

    this.ticketIdTarget.value = ticketId
    this.formTarget.action = `/tickets/${ticketId}/reject`
    this.modalTarget.classList.remove("hidden")
  }

  close() {
    this.modalTarget.classList.add("hidden")
  }
}