const reportLink = document.querySelector("[data-report-error]")

if (reportLink) {
  const { errorCode, errorTitle } = document.body.dataset
  const subject = encodeURIComponent(`Report - ${errorTitle}`)
  const body = encodeURIComponent(`Error Code: ${errorCode}\nRoute: ${location.href}\n\nDescribe the issue:\n`)
  reportLink.href = `mailto:contact@griffithict.club?subject=${subject}&body=${body}`
}

const backLink = document.querySelector("[data-history-back]")

if (backLink && history.length > 1) {
  backLink.addEventListener("click", (event) => {
    event.preventDefault()
    history.back()
  })
}
