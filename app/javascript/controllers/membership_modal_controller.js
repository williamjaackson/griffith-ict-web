import { Controller } from "@hotwired/stimulus"

const CHECK_SVG = `<svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3">
  <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7" />
</svg>`

export default class extends Controller {
  static targets = ["backdrop", "panel", "step1", "step2", "campusGroupsLink", "discordBadge", "campusGroupsBadge", "doneSection"]
  static values = {
    goldCoastUrl: String,
    brisbaneUrl: String,
    discordUrl: String
  }

  connect() {
    this._onKeydown = this._onKeydown.bind(this)
    this._onOpen = this.open.bind(this)
    this._onReturn = this._onReturn.bind(this)
    this._pendingStep = null
    this._completed = new Set()
    window.addEventListener("membership-modal:open", this._onOpen)
  }

  disconnect() {
    window.removeEventListener("membership-modal:open", this._onOpen)
    document.removeEventListener("visibilitychange", this._onReturn)
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

  trackClick(event) {
    this._pendingStep = event.currentTarget.dataset.step
    document.addEventListener("visibilitychange", this._onReturn)
  }

  back() {
    this._showStep1()
  }

  _onReturn() {
    if (document.visibilityState !== "visible") return
    document.removeEventListener("visibilitychange", this._onReturn)

    if (this._pendingStep === "discord") {
      this._markComplete(this.discordBadgeTarget, "discord")
    } else if (this._pendingStep === "campus-groups") {
      this._markComplete(this.campusGroupsBadgeTarget, "campus-groups")
    }
    this._pendingStep = null
  }

  _markComplete(badge, step) {
    badge.classList.remove("bg-brand-red")
    badge.classList.add("bg-green-600")
    badge.innerHTML = CHECK_SVG
    this._completed.add(step)

    if (this._completed.size === 2) {
      this.doneSectionTarget.classList.remove("hidden")
    }
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
