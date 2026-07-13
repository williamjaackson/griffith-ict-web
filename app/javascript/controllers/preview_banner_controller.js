import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.resizeObserver = new ResizeObserver(() => this.#updateHeight())
    this.resizeObserver.observe(this.element)
    this.#updateHeight()
  }

  disconnect() {
    this.resizeObserver.disconnect()
    document.documentElement.style.removeProperty("--preview-height")
  }

  #updateHeight() {
    document.documentElement.style.setProperty("--preview-height", `${this.element.offsetHeight}px`)
  }
}
