import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["backdrop", "panel", "title", "responsibilities", "note", "close"]

  connect() {
    this.handleKeydown = this.handleKeydown.bind(this)
  }

  disconnect() {
    document.body.classList.remove("overflow-hidden")
    document.removeEventListener("keydown", this.handleKeydown)
  }

  open(event) {
    const card = event.currentTarget

    this.previouslyFocused = card
    this.titleTarget.textContent = card.dataset.role
    this.responsibilitiesTarget.replaceChildren(
      ...JSON.parse(card.dataset.responsibilities).map((responsibility) => {
        const item = document.createElement("li")
        item.textContent = responsibility
        return item
      })
    )

    if (card.dataset.note) {
      this.noteTarget.textContent = card.dataset.note
      this.noteTarget.classList.remove("hidden")
    } else {
      this.noteTarget.textContent = ""
      this.noteTarget.classList.add("hidden")
    }

    this.backdropTarget.classList.remove("opacity-0", "pointer-events-none")
    this.backdropTarget.classList.add("opacity-100", "pointer-events-auto")
    this.panelTarget.classList.remove("scale-95", "opacity-0")
    this.panelTarget.classList.add("scale-100", "opacity-100")
    this.backdropTarget.setAttribute("aria-hidden", "false")
    document.body.classList.add("overflow-hidden")
    document.addEventListener("keydown", this.handleKeydown)
    this.closeTarget.focus()
  }

  close() {
    this.backdropTarget.classList.add("opacity-0", "pointer-events-none")
    this.backdropTarget.classList.remove("opacity-100", "pointer-events-auto")
    this.panelTarget.classList.add("scale-95", "opacity-0")
    this.panelTarget.classList.remove("scale-100", "opacity-100")
    this.backdropTarget.setAttribute("aria-hidden", "true")
    document.body.classList.remove("overflow-hidden")
    document.removeEventListener("keydown", this.handleKeydown)
    this.previouslyFocused?.focus()
  }

  closeBackdrop(event) {
    if (event.target === this.backdropTarget) this.close()
  }

  handleKeydown(event) {
    if (event.key === "Escape") this.close()
    if (event.key === "Tab") {
      event.preventDefault()
      this.closeTarget.focus()
    }
  }
}
