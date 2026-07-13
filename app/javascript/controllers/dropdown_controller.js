import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["trigger", "menu", "chevron"]

  connect() {
    this._close = this._close.bind(this)
    this.open = false
    document.addEventListener("click", this._close)
  }

  disconnect() {
    document.removeEventListener("click", this._close)
    if (this.open) this.#hide()
  }

  toggle(event) {
    event.preventDefault()
    event.stopPropagation()
    this.open ? this.#hide() : this.#show()
  }

  show() {
    if (this.open) return
    this.#show()
  }

  hide(event) {
    if (!this.open) return
    if (event?.relatedTarget && this.element.contains(event.relatedTarget)) return

    this.#hide()
  }

  keydown(event) {
    if (event.key !== "Escape" || !this.open) return

    event.preventDefault()
    this.#hide()
    this.triggerTarget.focus()
  }

  #isMobile() {
    return this.menuTarget.classList.contains("grid")
  }

  #show() {
    this.open = true
    this.triggerTarget.setAttribute("aria-expanded", "true")
    this.menuTarget.setAttribute("aria-hidden", "false")
    this.menuTarget.inert = false

    if (this.#isMobile()) {
      this.menuTarget.style.gridTemplateRows = "1fr"
      this.menuTarget.classList.remove("opacity-0")
      this.menuTarget.classList.add("opacity-100")
    } else {
      this.menuTarget.classList.remove("opacity-0", "pointer-events-none", "scale-95")
      this.menuTarget.classList.add("opacity-100", "pointer-events-auto", "scale-100")
    }

    if (this.hasChevronTarget) {
      this.chevronTarget.classList.add("rotate-180")
    }
  }

  #hide() {
    this.open = false
    this.triggerTarget.setAttribute("aria-expanded", "false")
    this.menuTarget.setAttribute("aria-hidden", "true")
    this.menuTarget.inert = true

    if (this.#isMobile()) {
      this.menuTarget.style.gridTemplateRows = "0fr"
      this.menuTarget.classList.remove("opacity-100")
      this.menuTarget.classList.add("opacity-0")
    } else {
      this.menuTarget.classList.add("opacity-0", "pointer-events-none", "scale-95")
      this.menuTarget.classList.remove("opacity-100", "pointer-events-auto", "scale-100")
    }

    if (this.hasChevronTarget) {
      this.chevronTarget.classList.remove("rotate-180")
    }
  }

  _close(event) {
    if (this.open && !this.element.contains(event.target)) this.#hide()
  }
}
