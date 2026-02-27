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

    card.addEventListener("transitionend", () => {
      this._animate(index + 1)
    }, { once: true })

    requestAnimationFrame(() => {
      card.classList.add(rotation)
    })
  }
}
