import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["backdrop", "panel", "logo", "name", "description", "link"]

  connect() {
    this._onKeydown = this._onKeydown.bind(this)
  }

  open(event) {
    const card = event.currentTarget
    const { perkName, perkLogo, perkDescription, perkWebsite } = card.dataset

    this.logoTarget.src = perkLogo
    this.logoTarget.alt = perkName
    this.nameTarget.textContent = perkName
    this.descriptionTarget.textContent = perkDescription
    this.linkTarget.href = perkWebsite
    this.linkTarget.textContent = `Check it out`

    this.backdropTarget.classList.remove("opacity-0", "pointer-events-none")
    this.backdropTarget.classList.add("opacity-100", "pointer-events-auto")
    this.panelTarget.classList.remove("scale-95", "opacity-0")
    this.panelTarget.classList.add("scale-100", "opacity-100")
    document.addEventListener("keydown", this._onKeydown)
  }

  close() {
    this.backdropTarget.classList.add("opacity-0", "pointer-events-none")
    this.backdropTarget.classList.remove("opacity-100", "pointer-events-auto")
    this.panelTarget.classList.add("scale-95", "opacity-0")
    this.panelTarget.classList.remove("scale-100", "opacity-100")
    document.removeEventListener("keydown", this._onKeydown)
  }

  closeBackdrop(event) {
    if (event.target === this.backdropTarget) this.close()
  }

  _onKeydown(event) {
    if (event.key === "Escape") this.close()
  }
}
