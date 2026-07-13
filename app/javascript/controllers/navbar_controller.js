import { Controller } from "@hotwired/stimulus"
import { focusableElements, trapFocus } from "lib/focus"

export default class extends Controller {
  static targets = ["menu", "toggle"]

  connect() {
    this._scroll = this._scroll.bind(this)
    this.element.classList.remove("transition-all", "duration-300")
    this._scroll()
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        this.element.classList.add("transition-all", "duration-300")
      })
    })
    window.addEventListener("scroll", this._scroll, { passive: true })
    this.open = false

    this.desktopQuery = window.matchMedia("(min-width: 768px)")
    this.closeAtDesktop = (event) => {
      if (event.matches && this.open) this.#setOpen(false)
    }
    this.desktopQuery.addEventListener("change", this.closeAtDesktop)
  }

  disconnect() {
    window.removeEventListener("scroll", this._scroll)
    this.desktopQuery?.removeEventListener("change", this.closeAtDesktop)
    this.#setOpen(false)
  }

  toggleMenu() {
    this.#setOpen(!this.open, true)
  }

  closeMenu() {
    if (!this.open) return
    this.#setOpen(false, true)
  }

  keydown(event) {
    if (!this.open) return

    if (event.key === "Tab") {
      trapFocus(event, focusableElements(this.element), this.toggleTarget)
      return
    }

    if (event.key !== "Escape") return

    event.preventDefault()
    this.#setOpen(false, true)
  }

  _scroll() {
    const scrolled = window.scrollY > 10
    this.element.classList.toggle("border-b-3", scrolled)
    this.element.classList.toggle("border-brand-black", scrolled)
  }

  #setOpen(open, moveFocus = false) {
    this.open = open
    this.menuTarget.classList.toggle("opacity-0", !open)
    this.menuTarget.classList.toggle("pointer-events-none", !open)
    this.menuTarget.classList.toggle("opacity-100", open)
    this.menuTarget.classList.toggle("pointer-events-auto", open)
    this.menuTarget.setAttribute("aria-hidden", String(!open))
    this.menuTarget.inert = !open
    this.toggleTarget.dataset.open = open
    this.toggleTarget.setAttribute("aria-expanded", String(open))
    document.body.classList.toggle("overflow-hidden", open)
    this.#setPageInert(open)

    if (open) {
      requestAnimationFrame(() => this.menuTarget.querySelector("a, button")?.focus())
    } else if (moveFocus) {
      this.toggleTarget.focus()
    }
  }

  #setPageInert(inert) {
    document.querySelectorAll("body > main, body > footer").forEach((element) => {
      element.inert = inert
    })
  }
}
