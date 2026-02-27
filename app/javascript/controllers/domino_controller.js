import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card"]

  connect() {
    this.observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          this._animate()
          this.observer.disconnect()
        }
      })
    }, { threshold: 0.2 })

    this.observer.observe(this.element)
  }

  disconnect() {
    this.observer?.disconnect()
  }

  _animate() {
    this.cardTargets.forEach((card, index) => {
      const rotation = card.dataset.rotation

      setTimeout(() => {
        card.classList.add("domino-ready")
        card.classList.remove("opacity-0", "translate-y-4")
        card.classList.add(rotation)
      }, index * 150)
    })
  }
}
