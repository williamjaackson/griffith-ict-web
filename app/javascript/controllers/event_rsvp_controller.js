import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["backdrop", "panel", "studentNumber", "emailPreview", "membership", "submit"]
  static values = { open: Boolean }

  connect() {
    this._onKeydown = this._onKeydown.bind(this)
    this._onOpen = this.open.bind(this)
    window.addEventListener("event-rsvp:open", this._onOpen)
    this.updateEmail()
    this.updateSubmit()
    if (this.openValue) this.open()
  }

  disconnect() {
    window.removeEventListener("event-rsvp:open", this._onOpen)
    document.removeEventListener("keydown", this._onKeydown)
  }

  open() {
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

  updateEmail() {
    const studentNumber = this.studentNumberTarget.value.trim().toLowerCase().replaceAll(" ", "")
    const example = "s1234567"
    this.emailPreviewTarget.textContent = `${studentNumber || example}@griffithuni.edu.au`
  }

  updateSubmit() {
    this.submitTarget.disabled = !this.membershipTarget.checked
  }

  openMembership() {
    this.close()
    window.dispatchEvent(new CustomEvent("membership-modal:open"))
  }

  _onKeydown(event) {
    if (event.key === "Escape") this.close()
  }
}
