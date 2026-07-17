import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  dismiss() {
    this.element.classList.add("alert-leaving")
    this.element.addEventListener("transitionend", () => this.element.remove(), { once: true })
  }
}
