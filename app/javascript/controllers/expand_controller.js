import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item", "toggle"]

  show() {
    this.itemTargets.forEach((item, index) => {
      item.classList.remove("hidden")
      setTimeout(() => {
        item.classList.add("revealed")
      }, index * 100)
    })
    this.toggleTarget.remove()
  }
}
