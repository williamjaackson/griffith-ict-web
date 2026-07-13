import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon", "name", "description", "link"]

  connect() {
    this.imageRequest = 0
  }

  populate(event) {
    const card = event.currentTarget
    const { perkName, perkIcon, perkDescription, perkWebsite } = card.dataset

    this.iconTarget.style.opacity = "0"
    this.iconTarget.alt = perkName
    const request = ++this.imageRequest
    const img = new Image()
    img.decoding = "async"
    img.src = perkIcon
    img.onload = () => {
      if (request !== this.imageRequest) return

      this.iconTarget.src = perkIcon
      this.iconTarget.style.opacity = "1"
    }
    img.onerror = () => {
      if (request !== this.imageRequest) return

      this.iconTarget.removeAttribute("src")
      this.iconTarget.alt = ""
    }
    this.nameTarget.textContent = perkName
    this.descriptionTarget.textContent = perkDescription
    this.linkTarget.href = perkWebsite
  }
}
