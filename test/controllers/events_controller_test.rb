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
    assert_select ".event-announcement.bg-brand-red.text-white a[href='#{event_path('griffith-ai-hackathon-2026')}']", text: /RSVP now/
  end

  test "index has an intentional empty upcoming state" do
    travel_to Time.iso8601("2026-08-02T10:00:00+10:00") do
      get events_path
    end

    assert_response :success
    assert_select "h3", text: "More events coming soon."
  end

  test "show presents the Hackathon details and RSVP modal" do
    get event_path("griffith-ai-hackathon-2026")

    assert_response :success
    assert_select "h1", text: "Griffith AI-Hackathon 2026"
    assert_select "body", text: /Saturday, 1 August 2026/
    assert_select "body", text: /10:00am–5:00pm/
    assert_select "body", text: /Gold Coast · Venue TBA/
    assert_select "body", text: /\$5 AUD/
    assert_select "body", text: /Membership is free/
    assert_select "body", text: /MEMBERSHIP IS REQUIRED\./
    assert_select "body", text: /2–4 people/
    assert_select "body", text: /Lunch provided/
    assert_select "body", text: /Tokens provided/
    assert_select "body", text: /\$100/
    assert_select "header img[loading='eager'][fetchpriority='high']", count: 1
    assert_select "header button", text: "RSVP now"
    assert_select "header", text: /Tickets coming soon/, count: 0
    assert_select "[data-controller='event-rsvp']" do
      assert_select "input[name='event_rsvp[full_name]']", count: 1
      assert_select "input[name='event_rsvp[student_number]'][placeholder='s1234567'][pattern='[sS][0-9]{7}']", count: 1
      assert_select "input[name='event_rsvp[student_email]']", count: 0
      assert_select "input[name='event_rsvp[membership_confirmed]'][required]", count: 1
      assert_select "input[type='submit'][disabled]", count: 1
      assert_select "strong", text: "s1234567@griffithuni.edu.au"
      assert_select "button", text: "Become a member"
    end
    assert_select "#terms", text: /Reviewed event terms will be published here/
  end

  test "records an RSVP and derives the student email" do
    assert_difference "EventRsvp.count", 1 do
      post event_rsvp_path("griffith-ai-hackathon-2026"), params: {
        event_rsvp: {
          full_name: "Alex Student",
          student_email: "forged@example.com",
          student_number: "s1234567",
          membership_confirmed: "1"
        }
      }
    end

    assert_redirected_to event_path("griffith-ai-hackathon-2026")
    assert_equal "s1234567@griffithuni.edu.au", EventRsvp.last.student_email
    assert_equal "s1234567", EventRsvp.last.student_number
    assert EventRsvp.last.membership_confirmed?
  end

  test "does not record an RSVP without membership confirmation" do
    assert_no_difference "EventRsvp.count" do
      post event_rsvp_path("griffith-ai-hackathon-2026"), params: {
        event_rsvp: {
          full_name: "Alex Student",
          student_number: "s1234567",
          membership_confirmed: "0"
        }
      }
    end

    assert_response :unprocessable_content
    assert_select "[data-controller='event-rsvp'][data-event-rsvp-open-value='true'] [role='alert']", text: /Membership confirmed must be accepted/
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
    assert_select "#rsvp", count: 0
  end

  test "does not accept an RSVP after the event ends" do
    travel_to Time.iso8601("2026-08-02T10:00:00+10:00") do
      assert_no_difference "EventRsvp.count" do
        post event_rsvp_path("griffith-ai-hackathon-2026"), params: {
          event_rsvp: {
            full_name: "Alex Student",
            student_number: "s1234567",
            membership_confirmed: "1"
          }
        }
      end
    end

    assert_redirected_to event_path("griffith-ai-hackathon-2026")
    assert_equal "RSVPs are closed for this event.", flash[:alert]
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

  test "event announcement disappears after the event ends" do
    travel_to Time.iso8601("2026-08-02T10:00:00+10:00") do
      get root_path
    end

    assert_response :success
    assert_select ".event-announcement", count: 0
  end
end
