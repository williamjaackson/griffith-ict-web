import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card"]

  connect() {
    this.observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          this._animate(0)
          this.observer.disconnect()
        }
      })
    }, { threshold: 0.2 })

    this.observer.observe(this.element)
  }

  disconnect() {
    this.observer?.disconnect()
  }

  _animate(index) {
    const card = this.cardTargets[index]
    if (!card) return

    const rotation = card.dataset.rotation

    setTimeout(() => {
      this._animate(index + 1)
    }, 150)

    requestAnimationFrame(() => {
      card.classList.add(rotation)
    })
  }
}
