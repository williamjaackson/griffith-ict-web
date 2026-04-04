import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { since: Number }
  static targets = ["days", "hours", "minutes", "seconds"]

  connect() {
    this.update()
    this.interval = setInterval(() => this.update(), 1000)
  }

  disconnect() {
    clearInterval(this.interval)
  }

  update() {
    const elapsed = Math.floor(Date.now() / 1000) - this.sinceValue
    const days = Math.floor(elapsed / 86400)
    const hours = Math.floor((elapsed % 86400) / 3600)
    const minutes = Math.floor((elapsed % 3600) / 60)
    const seconds = elapsed % 60

    this.daysTarget.textContent = days
    this.hoursTarget.textContent = String(hours).padStart(2, "0")
    this.minutesTarget.textContent = String(minutes).padStart(2, "0")
    this.secondsTarget.textContent = String(seconds).padStart(2, "0")
  }
}
