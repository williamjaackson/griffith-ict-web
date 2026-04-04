import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toast"]

  connect() {
    this.toastTargets.forEach((toast) => {
      setTimeout(() => {
        toast.style.opacity = "0"
        toast.style.transform = "translateX(20px)"
        toast.style.transition = "opacity 0.3s, transform 0.3s"
        setTimeout(() => toast.remove(), 300)
      }, 4000)
    })
  }
}
