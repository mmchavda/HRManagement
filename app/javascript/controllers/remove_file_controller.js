// remove_file_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }

  remove(event) {
    event.preventDefault()
    event.stopPropagation() // prevents bubbling up to the form

    if (confirm("Are you sure you want to remove this file?")) {
      fetch(this.urlValue, {
        method: "DELETE",
        headers: {
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
          "Accept": "application/json"
        }
      }).then(response => {
        if (response.ok) {
          this.element.closest("[id^='proof_']").remove()
        } else {
          alert("Failed to delete file.")
        }
      })
    }
  }
}
