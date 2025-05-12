import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "toggle"]

  connect() {
    this.originalText = this.contentTarget.textContent.trim()
    this.truncatedText = this.truncate(this.originalText, 20)
    this.expanded = false

    const wordCount = this.originalText.split(/\s+/).length
    if (wordCount > 20) {
      this.contentTarget.textContent = this.truncatedText
      this.toggleTarget.classList.remove("hidden")
    } else {
      this.toggleTarget.classList.add("hidden") // Hide if not needed
    }
  }

  toggle() {
    if (this.expanded) {
      this.contentTarget.textContent = this.truncatedText
      this.toggleTarget.textContent = "Read more"
    } else {
      this.contentTarget.textContent = this.originalText
      this.toggleTarget.textContent = "Read less"
    }
    this.expanded = !this.expanded
  }

  truncate(text, wordLimit) {
    const words = text.split(/\s+/)
    if (words.length <= wordLimit) return text
    return words.slice(0, wordLimit).join(" ") + "..."
  }
}
