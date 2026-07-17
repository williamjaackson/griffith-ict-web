import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.querySelectorAll("dialog[data-dialog-open-value='true']").forEach((dialog) => dialog.showModal())
  }

  open(event) {
    const dialog = document.getElementById(event.params.id)
    if (!dialog || dialog.open) return

    event.currentTarget.closest("dialog")?.close()
    dialog.returnFocusTo = event.currentTarget
    dialog.showModal()
  }

  close(event) {
    event.currentTarget.closest("dialog")?.close()
  }

  closeBackdrop(event) {
    if (event.target === event.currentTarget) event.currentTarget.close()
  }

  restoreFocus(event) {
    event.currentTarget.returnFocusTo?.focus()
  }
}
