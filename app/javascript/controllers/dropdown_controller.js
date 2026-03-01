import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "chevron"]

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
    const menu = this.menuTarget

    // Desktop: opacity/scale, Mobile: max-height accordion
    if (menu.classList.contains("max-h-0")) {
      menu.classList.remove("max-h-0", "opacity-0")
      menu.classList.add("max-h-96", "opacity-100", "mt-3")
    } else {
      menu.classList.remove("opacity-0", "pointer-events-none", "scale-95")
      menu.classList.add("opacity-100", "pointer-events-auto", "scale-100")
    }

    if (this.hasChevronTarget) {
      this.chevronTarget.classList.add("rotate-180")
    }
  }

  _hide() {
    this.open = false
    const menu = this.menuTarget

    if (menu.classList.contains("max-h-96")) {
      menu.classList.remove("max-h-96", "opacity-100", "mt-3")
      menu.classList.add("max-h-0", "opacity-0")
    } else {
      menu.classList.add("opacity-0", "pointer-events-none", "scale-95")
      menu.classList.remove("opacity-100", "pointer-events-auto", "scale-100")
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
