import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["btn", "panel"]
  static values = { index: { type: Number, default: 0 } }

  connect() {
    this._update()
  }

  select(event) {
    this.indexValue = parseInt(event.currentTarget.dataset.index, 10)
  }

  indexValueChanged() {
    this._update()
  }

  _update() {
    this.btnTargets.forEach((btn, i) => {
      const active = i === this.indexValue
      btn.classList.toggle("bg-brand-red", active)
      btn.classList.toggle("text-white", active)
      btn.classList.toggle("bg-white", !active)
      btn.classList.toggle("text-brand-black", !active)
    })

    this.panelTargets.forEach((panel, i) => {
      panel.classList.toggle("hidden", i !== this.indexValue)
    })
  }
}
