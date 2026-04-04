import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "menu", "input", "chevron"]
  static values = { open: { type: Boolean, default: false } }

  connect() {
    this._closeOnOutsideClick = this._closeOnOutsideClick.bind(this)
    document.addEventListener("click", this._closeOnOutsideClick)
  }

  disconnect() {
    document.removeEventListener("click", this._closeOnOutsideClick)
  }

  toggle() {
    this.openValue = !this.openValue
  }

  pick(event) {
    const value = event.currentTarget.dataset.value
    const label = event.currentTarget.dataset.label
    this.inputTarget.value = value
    this.buttonTarget.querySelector("[data-role='label']").textContent = label
    this.openValue = false
  }

  openValueChanged() {
    if (this.openValue) {
      this.menuTarget.classList.remove("opacity-0", "pointer-events-none", "scale-95")
      this.menuTarget.classList.add("opacity-100", "pointer-events-auto", "scale-100")
      this.chevronTarget.classList.add("rotate-180")
    } else {
      this.menuTarget.classList.add("opacity-0", "pointer-events-none", "scale-95")
      this.menuTarget.classList.remove("opacity-100", "pointer-events-auto", "scale-100")
      this.chevronTarget.classList.remove("rotate-180")
    }
  }

  _closeOnOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.openValue = false
    }
  }
}
