import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { text: String }
  static targets = ["button"]

  connect() {
    this.originalLabel = this.buttonTarget.textContent.trim()
  }

  disconnect() {
    clearTimeout(this.restoreTimer)
  }

  async copy() {
    clearTimeout(this.restoreTimer)
    this.buttonTarget.disabled = true

    try {
      await navigator.clipboard.writeText(this.textValue)
      this.#showStatus("Copied!")
    } catch {
      this.#showStatus("Copy failed")
    } finally {
      this.buttonTarget.disabled = false
    }
  }

  #showStatus(message) {
    this.buttonTarget.textContent = message
    this.restoreTimer = setTimeout(() => {
      this.buttonTarget.textContent = this.originalLabel
    }, 2000)
  }
}
