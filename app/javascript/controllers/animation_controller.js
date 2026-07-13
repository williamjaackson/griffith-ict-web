import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    if ("IntersectionObserver" in window) {
      this.intersectionObserver = new IntersectionObserver((entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add("entered")
            this.intersectionObserver.unobserve(entry.target)
          }
        })
      }, { threshold: 0.15 })
    }

    this.mutationObserver = new MutationObserver(() => this.#scan())

    this.#scan()

    this.mutationObserver.observe(this.element, { childList: true, subtree: true })
  }

  disconnect() {
    this.intersectionObserver?.disconnect()
    this.mutationObserver?.disconnect()
  }

  #scan() {
    this.element.querySelectorAll(".stagger").forEach((parent) => {
      const interval = this.#numberValue(parent.dataset.staggerInterval, 100)
      const defaultOffset = parent.classList.contains("enter") ? 0 : 100
      const offset = this.#numberValue(parent.dataset.staggerOffset, defaultOffset)
      Array.from(parent.children).forEach((child, i) => {
        child.style.setProperty("--stagger", `${offset + i * interval}ms`)
      })
    })

    this.element.querySelectorAll(".reveal:not(.entered)").forEach((el) => {
      if (this.intersectionObserver) {
        this.intersectionObserver.observe(el)
      } else {
        el.classList.add("entered")
      }
    })
  }

  #numberValue(value, fallback) {
    if (value === undefined) return fallback

    const number = Number.parseInt(value, 10)
    return Number.isNaN(number) ? fallback : number
  }
}
