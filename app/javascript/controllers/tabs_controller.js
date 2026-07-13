import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["btn", "panel"]
  static values = { index: { type: Number, default: 0 } }

  connect() {
    this._update()
  }

  select(event) {
    this.indexValue = Number.parseInt(event.currentTarget.dataset.index, 10)
  }

  navigate(event) {
    const currentIndex = this.btnTargets.indexOf(event.currentTarget)
    const lastIndex = this.btnTargets.length - 1
    const nextIndex = {
      ArrowLeft: (currentIndex - 1 + this.btnTargets.length) % this.btnTargets.length,
      ArrowRight: (currentIndex + 1) % this.btnTargets.length,
      Home: 0,
      End: lastIndex
    }[event.key]

    if (nextIndex === undefined) return

    event.preventDefault()
    this.indexValue = nextIndex
    this.btnTargets[nextIndex].focus()
  }

  indexValueChanged() {
    this._update()
  }

  _update() {
    this.btnTargets.forEach((btn, i) => {
      const active = i === this.indexValue
      btn.classList.toggle("text-brand-black", active)
      btn.classList.toggle("border-brand-red", active)
      btn.classList.toggle("text-brand-gray", !active)
      btn.classList.toggle("border-transparent", !active)
      btn.setAttribute("aria-selected", String(active))
      btn.tabIndex = active ? 0 : -1
    })

    this.panelTargets.forEach((panel, i) => {
      const active = i === this.indexValue
      panel.classList.toggle("hidden", !active)
      panel.hidden = !active
    })
  }
}
