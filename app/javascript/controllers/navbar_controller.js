import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.scroll = this.scroll.bind(this)
    window.addEventListener("scroll", this.scroll, { passive: true })
    this.scroll()
  }

  disconnect() {
    window.removeEventListener("scroll", this.scroll)
  }

  scroll() {
    this.element.classList.toggle("nav--scrolled", window.scrollY > 10)
  }
}
