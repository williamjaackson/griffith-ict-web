import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "chevron"]
  static values = { variant: { type: String, default: "desktop" } }

  connect() {
    this._close = this._close.bind(this)
    this.open = false
    document.addEventListener("click", this._close)
  }

  disconnect() {
    document.removeEventListener("click", this._close)
  }

  toggle(event) {
    event.preventDefault()
    event.stopPropagation()
    this.open ? this._hide() : this._show()
  }

  show() {
    if (this.open) return
    this._show()
  }

  hide() {
    if (!this.open) return
    this._hide()
  }

  _show() {
    this.open = true

    if (this.variantValue === "mobile") {
      this.menuTarget.style.gridTemplateRows = "1fr"
      this.menuTarget.classList.replace("opacity-0", "opacity-100")
    } else {
      this.menuTarget.classList.remove("opacity-0", "pointer-events-none", "scale-95")
      this.menuTarget.classList.add("opacity-100", "pointer-events-auto", "scale-100")
    }

    if (this.hasChevronTarget) {
      this.chevronTarget.classList.add("rotate-180")
    }
  }

  _hide() {
    this.open = false

    if (this.variantValue === "mobile") {
      this.menuTarget.style.gridTemplateRows = "0fr"
      this.menuTarget.classList.replace("opacity-100", "opacity-0")
    } else {
      this.menuTarget.classList.add("opacity-0", "pointer-events-none", "scale-95")
      this.menuTarget.classList.remove("opacity-100", "pointer-events-auto", "scale-100")
    }

    if (this.hasChevronTarget) {
      this.chevronTarget.classList.remove("rotate-180")
    }
  }

  _close(event) {
    if (!this.element.contains(event.target)) {
      this._hide()
    }
  }
}
