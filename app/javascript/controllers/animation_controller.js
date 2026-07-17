import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.intersectionObserver = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add("entered")
          this.intersectionObserver.unobserve(entry.target)
        }
      })
    }, { threshold: 0.15 })

    this.#scan()
  }

  disconnect() {
    this.intersectionObserver?.disconnect()
  }

  #scan() {
    this.element.querySelectorAll(".stagger").forEach((parent) => {
      if (parent.dataset.staggerApplied) return
      const interval = parseInt(parent.dataset.staggerInterval) || 100
      const defaultOffset = parent.classList.contains("enter") ? 0 : 100
      const offset = parseInt(parent.dataset.staggerOffset) || defaultOffset
      Array.from(parent.children).forEach((child, i) => {
        child.style.setProperty("--stagger", `${offset + i * interval}ms`)
      })
      parent.dataset.staggerApplied = true
    })

    this.element.querySelectorAll(".reveal:not(.entered)").forEach((el) => {
      this.intersectionObserver.observe(el)
    })
  }
}
