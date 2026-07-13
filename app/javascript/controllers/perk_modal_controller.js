import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon", "name", "description", "link"]

  populate(event) {
    const card = event.currentTarget
    const { perkName, perkIcon, perkDescription, perkWebsite } = card.dataset

    this.iconTarget.style.opacity = "0"
    this.iconTarget.alt = perkName
    const img = new Image()
    img.src = perkIcon
    img.onload = () => {
      this.iconTarget.src = perkIcon
      this.iconTarget.style.opacity = "1"
    }
    this.nameTarget.textContent = perkName
    this.descriptionTarget.textContent = perkDescription
    this.linkTarget.href = perkWebsite
  }
}
