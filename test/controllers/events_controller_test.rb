require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  test "index shows upcoming events, event types, and an empty archive" do
    get events_path

    assert_response :success
    assert_select "h1", text: /What's on/
    assert_select "h3", text: "Griffith AI-Hackathon 2026"
    assert_select "h3", text: "Social Events"
    assert_select "h2", text: "Past events."
    assert_select "h3", text: "The archive starts here."
    assert_select "nav a[href='#{events_path}']", minimum: 1
    assert_select "footer a[href='#{events_path}']", minimum: 1
    assert_select "article img[loading='lazy']", minimum: 1
  end

  test "index has an intentional empty upcoming state" do
    travel_to Time.iso8601("2026-08-02T10:00:00+10:00") do
      get events_path
    end

    assert_response :success
    assert_select "h3", text: "More events coming soon."
  end

  test "show presents the Hackathon details and disabled actions" do
    get event_path("griffith-ai-hackathon-2026")

    assert_response :success
    assert_select "h1", text: "Griffith AI-Hackathon 2026"
    assert_select "body", text: /Saturday, 1 August 2026/
    assert_select "body", text: /10:00am–5:00pm/
    assert_select "body", text: /Gold Coast · Venue TBA/
    assert_select "body", text: /\$5 AUD/
    assert_select "body", text: /Membership is free/
    assert_select "body", text: /2–4 people/
    assert_select "body", text: /Lunch provided/
    assert_select "body", text: /Tokens provided/
    assert_select "body", text: /\$100/
    assert_select "[aria-disabled='true']", text: "Tickets coming soon"
    assert_select "header img[loading='eager'][fetchpriority='high']", count: 1
    assert_select "#terms", text: /Reviewed event terms will be published here/
  end

  test "show returns not found for an unknown event" do
    get event_path("not-an-event")

    assert_response :not_found
  end

  test "completed events remain accessible with closed tickets" do
    travel_to Time.iso8601("2026-08-02T10:00:00+10:00") do
      get event_path("griffith-ai-hackathon-2026")
    end

    assert_response :success
    assert_select ".badge", text: "Past event"
    assert_select "[aria-disabled='true']", text: "Event ended"
  end

  test "show emits event-specific metadata and JSON-LD without an offer" do
    get event_path("griffith-ai-hackathon-2026")

    assert_select "title", text: "Griffith AI-Hackathon 2026 | Griffith ICT Club"
    assert_select "meta[property='og:type'][content='event']", count: 1
    assert_select "meta[property='og:title'][content='Griffith AI-Hackathon 2026 | Griffith ICT Club']", count: 1
    assert_select "meta[property='og:image'][content*='griffith-ai-hackathon-2026']", count: 1
    assert_select "link[rel='canonical'][href='https://griffithict.club/events/griffith-ai-hackathon-2026']", count: 1

    json = JSON.parse(css_select("script[type='application/ld+json']").first.text)
    assert_equal "Event", json.fetch("@type")
    assert_equal "Griffith AI-Hackathon 2026", json.fetch("name")
    assert_equal "2026-08-01T10:00:00+10:00", json.fetch("startDate")
    assert_equal "Gold Coast · Venue TBA", json.dig("location", "name")
    assert_not json.key?("offers")
  end

  test "homepage features the next event and links to event browsing" do
    get root_path

    assert_response :success
    assert_select "#events h2", text: "Griffith AI-Hackathon 2026"
    assert_select "#events a[href='#{event_path('griffith-ai-hackathon-2026')}']", text: "View event"
    assert_select "a[href='#{events_path}']", text: "All events"
    assert_select "#events img[loading='lazy']", count: 1
  end
end
