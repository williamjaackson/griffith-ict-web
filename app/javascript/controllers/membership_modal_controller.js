import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["backdrop", "panel", "step1", "step2", "campusGroupsLink"]
  static values = {
    goldCoastUrl: String,
    brisbaneUrl: String,
    discordUrl: String
  }

  connect() {
    this._onKeydown = this._onKeydown.bind(this)
    this._onOpen = this.open.bind(this)
    window.addEventListener("membership-modal:open", this._onOpen)
  }

  disconnect() {
    window.removeEventListener("membership-modal:open", this._onOpen)
  }

  open() {
    this.backdropTarget.classList.remove("opacity-0", "pointer-events-none")
    this.backdropTarget.classList.add("opacity-100", "pointer-events-auto")
    this.panelTarget.classList.remove("scale-95", "opacity-0")
    this.panelTarget.classList.add("scale-100", "opacity-100")
    this._showStep1()
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

  selectLocation(event) {
    const location = event.currentTarget.dataset.location
    if (location === "gold-coast") {
      this.campusGroupsLinkTarget.href = this.goldCoastUrlValue
    } else {
      this.campusGroupsLinkTarget.href = this.brisbaneUrlValue
    }
    this._showStep2()
  }

  back() {
    this._showStep1()
  }

  _showStep1() {
    this.step1Target.classList.remove("hidden")
    this.step2Target.classList.add("hidden")
  }

  _showStep2() {
    this.step1Target.classList.add("hidden")
    this.step2Target.classList.remove("hidden")
  }

  _onKeydown(event) {
    if (event.key === "Escape") this.close()
  }
}
