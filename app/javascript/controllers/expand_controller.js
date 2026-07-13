import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item", "toggle"]

  disconnect() {
    this.timers?.forEach((timer) => clearTimeout(timer))
  }

  show() {
    const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches
    this.timers = []

    this.itemTargets.forEach((item, index) => {
      item.classList.remove("hidden")
      if (reduceMotion) {
        item.classList.add("revealed")
      } else {
        this.timers.push(setTimeout(() => {
          item.classList.add("revealed")
        }, index * 100))
      }
    })
    this.toggleTarget.remove()
  }
}
