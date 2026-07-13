import { Controller } from "@hotwired/stimulus"
import { focusableElements, trapFocus } from "lib/focus"

export default class extends Controller {
  static targets = ["dialog"]

  connect() {
    this.handleKeydown = this.handleKeydown.bind(this)
  }

  disconnect() {
    if (this.openDialog) {
      this.#hide(this.openDialog, false)
      return
    }

    document.removeEventListener("keydown", this.handleKeydown)
    document.body.classList.remove("overflow-hidden")
    this.#restorePage()
  }

  open(event) {
    const dialog = this.dialogTargets.find((candidate) => candidate.id === event.params.id)
    if (!dialog || dialog === this.openDialog) return

    if (this.openDialog) this.#hide(this.openDialog, false)

    this.openDialog = dialog
    this.previouslyFocused = document.activeElement === document.body ? event.currentTarget : document.activeElement
    dialog.inert = false
    dialog.setAttribute("aria-hidden", "false")
    dialog.classList.remove("opacity-0", "pointer-events-none")
    dialog.classList.add("opacity-100", "pointer-events-auto")
    this.#isolate(dialog)

    const panel = this.#panelFor(dialog)
    panel.classList.remove("scale-95", "opacity-0")
    panel.classList.add("scale-100", "opacity-100")

    document.body.classList.add("overflow-hidden")
    document.addEventListener("keydown", this.handleKeydown)
    dialog.dispatchEvent(new CustomEvent("modal:opened", { bubbles: true }))

    requestAnimationFrame(() => {
      const initialFocus = dialog.querySelector("[data-modal-initial-focus]")
      const firstControl = focusableElements(dialog)[0]
      const focusTarget = initialFocus || firstControl || panel
      focusTarget.focus()
    })
  }

  close(event) {
    const dialog = event?.currentTarget.closest("[data-modal-target='dialog']") || this.openDialog
    if (dialog) this.#hide(dialog)
  }

  closeBackdrop(event) {
    if (event.target === event.currentTarget) this.close(event)
  }

  handleKeydown(event) {
    if (event.key === "Escape") {
      this.close()
    } else if (event.key === "Tab") {
      const panel = this.#panelFor(this.openDialog)
      trapFocus(event, focusableElements(this.openDialog), panel)
    }
  }

  #hide(dialog, restoreFocus = true) {
    dialog.classList.add("opacity-0", "pointer-events-none")
    dialog.classList.remove("opacity-100", "pointer-events-auto")
    dialog.setAttribute("aria-hidden", "true")
    dialog.inert = true

    const panel = this.#panelFor(dialog)
    panel.classList.add("scale-95", "opacity-0")
    panel.classList.remove("scale-100", "opacity-100")

    document.body.classList.remove("overflow-hidden")
    document.removeEventListener("keydown", this.handleKeydown)
    dialog.dispatchEvent(new CustomEvent("modal:closed", { bubbles: true }))
    this.#restorePage()

    this.openDialog = null
    if (restoreFocus && this.previouslyFocused?.isConnected) this.previouslyFocused.focus()
    this.previouslyFocused = null
  }

  #panelFor(dialog) {
    return dialog.querySelector("[data-modal-target='panel']")
  }

  #isolate(dialog) {
    this.inertedElements = []
    let current = dialog

    while (current.parentElement && current !== document.body) {
      Array.from(current.parentElement.children).forEach((sibling) => {
        if (sibling !== current && !sibling.inert) {
          sibling.inert = true
          this.inertedElements.push(sibling)
        }
      })
      current = current.parentElement
    }
  }

  #restorePage() {
    this.inertedElements?.forEach((element) => { element.inert = false })
    this.inertedElements = []
  }
}
