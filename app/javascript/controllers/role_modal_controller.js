import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "backdrop",
    "panel",
    "title",
    "member",
    "responsibilities",
    "applicationActions",
    "timeline"
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

    const applicationsAreOpen = card.dataset.applicationStatus === "open" && card.dataset.applicationUrl
    const shouldShowApplications = card.dataset.roleType === "appointed" || applicationsAreOpen

    this.applicationActionsTarget.classList.toggle("hidden", !shouldShowApplications)
    this.applicationActionsTarget.replaceChildren()

    if (shouldShowApplications) {
      const applicationControl = document.createElement(applicationsAreOpen ? "a" : "button")
      applicationControl.className = applicationsAreOpen ? "btn btn-primary w-full" : "btn btn-disabled w-full"
      applicationControl.textContent = applicationsAreOpen ? "Applications open" : "Applications closed"

      if (applicationsAreOpen) {
        applicationControl.href = card.dataset.applicationUrl
      } else {
        applicationControl.type = "button"
        applicationControl.disabled = true
      }

      this.applicationActionsTarget.append(applicationControl)
    }

    this.timelineTarget.replaceChildren(
      ...JSON.parse(card.dataset.history).reverse().map((entry) => {
        const item = document.createElement("li")
        item.className = "relative pl-6 pb-5 last:pb-0"

        const marker = document.createElement("span")
        marker.className = "absolute -left-[7px] top-1.5 w-3 h-3 bg-brand-red border-2 border-brand-bg"

        const nameRow = document.createElement("div")
        nameRow.className = "flex flex-wrap items-center gap-2"

        const name = document.createElement("p")
        name.className = "font-bold text-brand-black"
        name.textContent = entry.name
        nameRow.append(name)

        if (entry.acting) {
          const actingBadge = document.createElement("span")
          actingBadge.className = "inline-flex bg-brand-red/10 text-brand-red px-2 py-0.5 text-xs font-bold uppercase"
          actingBadge.textContent = "Acting"
          nameRow.append(actingBadge)
        }

        const period = document.createElement("p")
        period.className = "text-sm"
        const duration = this.formatDuration(entry.period)
        period.textContent = duration ? `${entry.period} · ${duration}` : entry.period

        item.append(marker, nameRow, period)
        return item
      })
    )

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

  formatDuration(period) {
    if (!period.includes(" - ")) return null

    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    const [start, end] = period.split(" - ")
    const [startMonth, startYear] = start.split(" ")
    const now = new Date()
    const [endMonth, endYear] = end === "Present"
      ? [months[now.getMonth()], now.getFullYear().toString()]
      : end.split(" ")

    const monthCount = ((Number(endYear) - Number(startYear)) * 12) + months.indexOf(endMonth) - months.indexOf(startMonth) + 1
    const years = Math.floor(monthCount / 12)
    const remainingMonths = monthCount % 12
    const parts = []

    if (years) parts.push(`${years} yr${years === 1 ? "" : "s"}`)
    if (remainingMonths) parts.push(`${remainingMonths} mo${remainingMonths === 1 ? "" : "s"}`)

    return parts.join(" ")
  }
}
