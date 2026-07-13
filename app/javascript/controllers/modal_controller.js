import { Controller } from "@hotwired/stimulus"

const FOCUSABLE_SELECTOR = [
  "a[href]",
  "button:not([disabled])",
  "input:not([disabled])",
  "select:not([disabled])",
  "textarea:not([disabled])",
  "[tabindex]:not([tabindex='-1'])"
].join(",")

export default class extends Controller {
  static targets = ["dialog"]

  connect() {
    this.handleKeydown = this.handleKeydown.bind(this)
  }

  disconnect() {
    document.removeEventListener("keydown", this.handleKeydown)
    document.body.classList.remove("overflow-hidden")
  }

  open(event) {
    const dialog = this.dialogTargets.find((candidate) => candidate.id === event.params.id)
    if (!dialog || dialog === this.openDialog) return

    if (this.openDialog) this.#hide(this.openDialog, false)

    this.openDialog = dialog
    this.previouslyFocused = event.currentTarget
    dialog.inert = false
    dialog.setAttribute("aria-hidden", "false")
    dialog.classList.remove("opacity-0", "pointer-events-none")
    dialog.classList.add("opacity-100", "pointer-events-auto")

    const panel = this.#panelFor(dialog)
    panel.classList.remove("scale-95", "opacity-0")
    panel.classList.add("scale-100", "opacity-100")

    document.body.classList.add("overflow-hidden")
    document.addEventListener("keydown", this.handleKeydown)
    dialog.dispatchEvent(new CustomEvent("modal:opened", { bubbles: true }))

    requestAnimationFrame(() => {
      const initialFocus = dialog.querySelector("[data-modal-initial-focus]")
      const firstControl = this.#focusableElements(dialog)[0]
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
      this.#trapFocus(event)
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

    this.openDialog = null
    if (restoreFocus && this.previouslyFocused?.isConnected) this.previouslyFocused.focus()
    this.previouslyFocused = null
  }

  #panelFor(dialog) {
    return dialog.querySelector("[data-modal-target='panel']")
  }

  #focusableElements(dialog) {
    return Array.from(dialog.querySelectorAll(FOCUSABLE_SELECTOR)).filter((element) => (
      element.tabIndex >= 0 && element.getClientRects().length > 0
    ))
  }

  #trapFocus(event) {
    if (!this.openDialog) return

    const controls = this.#focusableElements(this.openDialog)
    if (controls.length === 0) {
      event.preventDefault()
      this.#panelFor(this.openDialog).focus()
      return
    }

    const first = controls[0]
    const last = controls[controls.length - 1]

    if (event.shiftKey && document.activeElement === first) {
      event.preventDefault()
      last.focus()
    } else if (!event.shiftKey && document.activeElement === last) {
      event.preventDefault()
      first.focus()
    }
  }
}
