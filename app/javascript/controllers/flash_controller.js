import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  disconnect() {
    this.timers?.forEach((timer) => clearTimeout(timer))
  }

  dismiss(event) {
    const toast = event.currentTarget.closest("[data-flash-target='toast']")
    toast.style.opacity = "0"
    toast.style.transition = "opacity 0.2s"
    this.timers ||= []
    this.timers.push(setTimeout(() => toast.remove(), 200))
  }
}
