import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item"]

  connect() {
    this.#applyStaggerDelays()

    this.observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add("revealed")
          this.observer.unobserve(entry.target)
        }
      })
    }, { threshold: 0.15 })

    this.itemTargets.forEach((item) => this.observer.observe(item))
  }

  disconnect() {
    this.observer?.disconnect()
  }

  #applyStaggerDelays() {
    this.element.querySelectorAll(".stagger").forEach((parent) => {
      Array.from(parent.children).forEach((child, i) => {
        child.style.setProperty("--stagger", `${i * 100}ms`)
      })
    })
  }
}
