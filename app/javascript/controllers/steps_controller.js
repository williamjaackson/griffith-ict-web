import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "step"]
  static values = { index: { type: Number, default: 0 } }

  connect() {
    this.#render()
  }

  indexValueChanged() {
    this.#render()
  }

  next() {
    this.#moveTo(this.indexValue + 1)
  }

  previous() {
    this.#moveTo(this.indexValue - 1)
  }

  #moveTo(index) {
    if (index < 0 || index >= this.panelTargets.length) return

    this.indexValue = index
    requestAnimationFrame(() => this.panelTargets[index].querySelector("[data-steps-focus]")?.focus())
  }

  #render() {
    if (!this.hasPanelTarget) return

    this.panelTargets.forEach((panel, index) => {
      panel.hidden = index !== this.indexValue
    })

    this.stepTargets.forEach((step, index) => {
      const state = index < this.indexValue ? "complete" : index === this.indexValue ? "current" : "upcoming"
      step.dataset.state = state

      if (state === "current") {
        step.setAttribute("aria-current", "step")
      } else {
        step.removeAttribute("aria-current")
      }
    })
  }
}
