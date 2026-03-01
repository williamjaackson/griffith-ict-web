import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "toggle"]

  connect() {
    this._scroll = this._scroll.bind(this)
    this._scroll()
    requestAnimationFrame(() => {
      this.element.classList.add("transition-all", "duration-300")
    })
    window.addEventListener("scroll", this._scroll, { passive: true })
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
    this._collapseAccordions()
    this.toggleMenu()
  }

  _collapseAccordions() {
    this.menuTarget
      .querySelectorAll("[data-controller='accordion']")
      .forEach((el) => {
        const controller = this.application.getControllerForElementAndIdentifier(el, "accordion")
        if (controller?.open) controller.collapse()
      })
  }

  _scroll() {
    const scrolled = window.scrollY > 10
    this.element.classList.toggle("bg-brand-bg", scrolled)
    this.element.classList.toggle("border-b-3", scrolled)
    this.element.classList.toggle("border-brand-black", scrolled)
  }
}
