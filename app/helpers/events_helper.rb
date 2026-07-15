module EventsHelper
  def event_date(event)
    event.local_starts_at.strftime("%A, %-d %B %Y")
  end

  def event_time(event)
    start_time = event.local_starts_at.strftime("%-I:%M%P")
    end_time = event.local_ends_at.strftime("%-I:%M%P")
    "#{start_time}–#{end_time}"
  end

  def event_price(event)
    amount = event.admission.fetch("price_cents")
    formatted = amount.modulo(100).zero? ? "$#{amount / 100}" : format("$%.2f", amount / 100.0)
    "#{formatted} #{event.admission.fetch('currency')}"
  end

  def event_location(event)
    parts = [ event.location.fetch("region") ]
    parts << (event.location.fetch("venue_tba") ? "Venue TBA" : event.location.fetch("venue"))
    parts.compact.join(" · ")
  end

  def event_status_label(event, at: Time.current)
    case event.status(at: at)
    when :happening_now then "Happening now"
    when :past then "Past event"
    else "Upcoming"
    end
  end

  def event_ticket_label(event)
    case event.ticket_state
    when "available" then "Get tickets"
    when "sold_out" then "Sold out"
    when "closed" then "Event ended"
    else "Tickets coming soon"
    end
  end

  def event_absolute_asset_url(event)
    URI.join(Rails.application.config.meta[:url], asset_path(event.image)).to_s
  end

  def event_json_ld(event)
    data = {
      "@context" => "https://schema.org",
      "@type" => "Event",
      "name" => event.title,
      "description" => event.summary,
      "startDate" => event.starts_at.iso8601,
      "endDate" => event.ends_at.iso8601,
      "eventStatus" => event.past? ? "https://schema.org/EventCompleted" : "https://schema.org/EventScheduled",
      "eventAttendanceMode" => "https://schema.org/OfflineEventAttendanceMode",
      "image" => [ event_absolute_asset_url(event) ],
      "url" => "#{Rails.application.config.meta[:url]}#{event_path(event.slug)}",
      "location" => {
        "@type" => "Place",
        "name" => event_location(event),
        "address" => {
          "@type" => "PostalAddress",
          "addressLocality" => event.location.fetch("region"),
          "streetAddress" => event.location.fetch("address")
        }.compact
      },
      "organizer" => {
        "@type" => "Organization",
        "name" => Rails.application.config.meta[:site_name],
        "url" => Rails.application.config.meta[:url]
      }
    }

    if event.ticket_state == "available"
      data["offers"] = {
        "@type" => "Offer",
        "url" => event.admission.fetch("url"),
        "price" => format("%.2f", event.admission.fetch("price_cents") / 100.0),
        "priceCurrency" => event.admission.fetch("currency"),
        "availability" => "https://schema.org/InStock"
      }
    end

    data
  end
end
