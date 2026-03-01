import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "chevron"]

  connect() {
    this.open = false
  }

  toggle(event) {
    event.preventDefault()
    event.stopPropagation()
    this.open ? this.collapse() : this.expand()
  }

  expand() {
    this.open = true
    this.panelTarget.style.gridTemplateRows = "1fr"
    this.panelTarget.classList.replace("opacity-0", "opacity-100")
    if (this.hasChevronTarget) this.chevronTarget.classList.add("rotate-180")
  }

  collapse() {
    this.open = false
    this.panelTarget.style.gridTemplateRows = "0fr"
    this.panelTarget.classList.replace("opacity-100", "opacity-0")
    if (this.hasChevronTarget) this.chevronTarget.classList.remove("rotate-180")
  }
}
