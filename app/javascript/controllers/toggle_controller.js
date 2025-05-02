import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["assignSection", "unassignSection"]

  showAssign() {
    if (this.hasAssignSectionTarget) {
      this.assignSectionTarget.classList.toggle("hidden")
    }
    if (this.hasUnassignSectionTarget) {
      this.unassignSectionTarget.classList.add("hidden")
    }
  }

  showUnassign() {
    if (this.hasUnassignSectionTarget) {
      this.unassignSectionTarget.classList.toggle("hidden")
    }
    if (this.hasAssignSectionTarget) {
      this.assignSectionTarget.classList.add("hidden")
    }
  }
}
