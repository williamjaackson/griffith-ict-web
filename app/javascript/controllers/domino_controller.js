import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card"]

  connect() {
    this.observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          this._animate(this.cardTargets.length - 1)
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
    if (index < 0) return
    const card = this.cardTargets[index]

    const rotation = card.dataset.rotation

    setTimeout(() => {
      this._animate(index - 1)
    }, 150)

    requestAnimationFrame(() => {
      card.classList.add(rotation)
    })
  }
}
