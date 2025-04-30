import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["section", "icon"]

  connect() {
    console.log("✅ Audit is connected")
  }

  toggle() {
    this.sectionTarget.classList.toggle("hidden")
    this.iconTarget.classList.toggle("rotate-45")
  }
}
