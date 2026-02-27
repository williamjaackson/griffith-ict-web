import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "toggle"]

  connect() {
    this._scroll = this._scroll.bind(this)
    window.addEventListener("scroll", this._scroll, { passive: true })
    this._scroll()
    this.open = false
  }

  disconnect() {
    window.removeEventListener("scroll", this._scroll)
  }

  toggleMenu() {
    this.open = !this.open
    this.menuTarget.classList.toggle("opacity-0", !this.open)
    this.menuTarget.classList.toggle("pointer-events-none", !this.open)
    this.menuTarget.classList.toggle("opacity-100", this.open)
    this.menuTarget.classList.toggle("pointer-events-auto", this.open)
    this.toggleTarget.dataset.open = this.open
  }

  closeMenu() {
    if (!this.open) return
    this.toggleMenu()
  }

  _scroll() {
    const scrolled = window.scrollY > 10
    this.element.classList.toggle("bg-brand-bg", scrolled)
    this.element.classList.toggle("border-b-3", scrolled)
    this.element.classList.toggle("border-brand-black", scrolled)
  }
}
