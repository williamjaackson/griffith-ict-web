import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  dismiss(event) {
    const toast = event.currentTarget.closest("[data-flash-target='toast']")
    toast.style.opacity = "0"
    toast.style.transition = "opacity 0.2s"
    setTimeout(() => toast.remove(), 200)
  }
}
