import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "backdrop",
    "panel",
    "title",
    "member",
    "responsibilities",
    "applicationActions",
    "applicationsOpen",
    "applicationsClosed"
  ]

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
    this.memberTarget.textContent = card.dataset.memberName
    this.responsibilitiesTarget.replaceChildren(
      ...JSON.parse(card.dataset.responsibilities).map((responsibility) => {
        const item = document.createElement("li")
        item.textContent = responsibility
        return item
      })
    )

    const roleIsUnassigned = card.dataset.memberName === "Unassigned"
    const applicationsAreOpen = card.dataset.applicationStatus === "open" && card.dataset.applicationUrl

    this.applicationActionsTarget.classList.toggle("hidden", !roleIsUnassigned)
    this.applicationsOpenTarget.classList.toggle("hidden", !applicationsAreOpen)
    this.applicationsClosedTarget.classList.toggle("hidden", applicationsAreOpen)
    this.applicationsOpenTarget.href = applicationsAreOpen ? card.dataset.applicationUrl : "#"

    this.backdropTarget.classList.remove("opacity-0", "pointer-events-none")
    this.backdropTarget.classList.add("opacity-100", "pointer-events-auto")
    this.panelTarget.classList.remove("scale-95", "opacity-0")
    this.panelTarget.classList.add("scale-100", "opacity-100")
    this.backdropTarget.setAttribute("aria-hidden", "false")
    document.body.classList.add("overflow-hidden")
    document.addEventListener("keydown", this.handleKeydown)
    this.panelTarget.focus()
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
  }
}
