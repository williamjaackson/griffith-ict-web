import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.scrollHandler = () => {
      if (window.scrollY > 0) {
        document.documentElement.classList.add("has-scrolled")
      } else {
        document.documentElement.classList.remove("has-scrolled")
      }
    }
    window.addEventListener("scroll", this.scrollHandler, { passive: true })
  }

  disconnect() {
    window.removeEventListener("scroll", this.scrollHandler)
    document.documentElement.classList.remove("has-scrolled")
  }
}
