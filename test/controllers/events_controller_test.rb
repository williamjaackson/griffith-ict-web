require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  # Fixture events live in test/fixtures/files/events. The workshop runs on
  # 9 May 2026 and the hackathon on 6 March 2027, so every test pins the clock
  # to keep the upcoming and past sections deterministic.
  BEFORE_BOTH = "2026-01-05T09:00:00+10:00".freeze
  BETWEEN = "2026-09-01T09:00:00+10:00".freeze
  AFTER_BOTH = "2027-04-01T09:00:00+10:00".freeze

  test "index lists upcoming events and archives completed ones" do
    travel_to Time.iso8601(BETWEEN) do
      get events_path
    end

    assert_response :success
    assert_select "h1", text: /What's on/
    assert_select "#upcoming h3", text: "Test Hackathon 2027"
    assert_select "#past h3", text: "Test Workshop 2026"
    assert_select "h3", text: "Social Events"
    assert_select "nav a[href='#{events_path}']", minimum: 1
    assert_select "footer a[href='#{events_path}']", minimum: 1
    assert_select "article img[loading='lazy']", minimum: 1
    assert_select ".event-announcement.bg-brand-red.text-white a[href='#{event_path('test-hackathon')}']", text: /RSVP now/
  end

  test "index has an intentional empty upcoming state" do
    travel_to Time.iso8601(AFTER_BOTH) do
      get events_path
    end

    assert_response :success
    assert_select "h3", text: "More events coming soon."
    assert_select "#past h3", text: "Test Hackathon 2027"
  end

  test "index has an intentional empty archive state" do
    travel_to Time.iso8601(BEFORE_BOTH) do
      get events_path
    end

    assert_response :success
    assert_select "h3", text: "The archive starts here."
    assert_select "#upcoming h3", text: "Test Workshop 2026"
  end

  test "show presents the event details and RSVP modal" do
    travel_to Time.iso8601(BETWEEN) do
      get event_path("test-hackathon")
    end

    assert_response :success
    assert_select "h1", text: "Test Hackathon 2027"
    assert_select "body", text: /Saturday, 6 March 2027/
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

  test "show renders published terms and a venue" do
    travel_to Time.iso8601(BEFORE_BOTH) do
      get event_path("test-workshop")
    end

    assert_response :success
    assert_select "body", text: /Nathan · N44 Lecture Theatre/
    assert_select "body", text: /\$12\.50 AUD/
    assert_select "#terms ol li", count: 2
    assert_select "#terms li", text: "Attendees must bring a laptop."
    assert_select "#terms", text: /Reviewed event terms will be published here/, count: 0
    assert_select "[data-controller='event-rsvp']", count: 0
  end

  test "records an RSVP and derives the student email" do
    assert_difference "EventRsvp.count", 1 do
      travel_to Time.iso8601(BETWEEN) do
        post event_rsvp_path("test-hackathon"), params: {
          event_rsvp: {
            full_name: "Alex Student",
            student_email: "forged@example.com",
            student_number: "s1234567",
            membership_confirmed: "1"
          }
        }
      end
    end

    assert_redirected_to event_path("test-hackathon")
    assert_equal "s1234567@griffithuni.edu.au", EventRsvp.last.student_email
    assert_equal "s1234567", EventRsvp.last.student_number
    assert EventRsvp.last.membership_confirmed?
  end

  test "does not record an RSVP without membership confirmation" do
    assert_no_difference "EventRsvp.count" do
      travel_to Time.iso8601(BETWEEN) do
        post event_rsvp_path("test-hackathon"), params: {
          event_rsvp: {
            full_name: "Alex Student",
            student_number: "s1234567",
            membership_confirmed: "0"
          }
        }
      end
    end

    assert_response :unprocessable_content
    assert_select "[data-controller='event-rsvp'][data-event-rsvp-open-value='true'] [role='alert']", text: /Membership confirmed must be accepted/
  end

  test "show returns not found for an unknown event" do
    get event_path("not-an-event")

    assert_response :not_found
  end

  test "completed events remain accessible with closed tickets" do
    travel_to Time.iso8601(AFTER_BOTH) do
      get event_path("test-hackathon")
    end

    assert_response :success
    assert_select ".badge", text: "Past event"
    assert_select "[aria-disabled='true']", text: "Event ended"
    assert_select "#rsvp", count: 0
  end

  test "does not accept an RSVP after the event ends" do
    travel_to Time.iso8601(AFTER_BOTH) do
      assert_no_difference "EventRsvp.count" do
        post event_rsvp_path("test-hackathon"), params: {
          event_rsvp: {
            full_name: "Alex Student",
            student_number: "s1234567",
            membership_confirmed: "1"
          }
        }
      end
    end

    assert_redirected_to event_path("test-hackathon")
    assert_equal "RSVPs are closed for this event.", flash[:alert]
  end

  test "show emits event-specific metadata and JSON-LD without an offer" do
    travel_to Time.iso8601(BETWEEN) do
      get event_path("test-hackathon")
    end

    assert_select "title", text: "Test Hackathon 2027 | Griffith ICT Club"
    assert_select "meta[property='og:type'][content='event']", count: 1
    assert_select "meta[property='og:title'][content='Test Hackathon 2027 | Griffith ICT Club']", count: 1
    assert_select "meta[property='og:image'][content*='test-hackathon']", count: 1
    assert_select "link[rel='canonical'][href='https://griffithict.club/events/test-hackathon']", count: 1

    json = JSON.parse(css_select("script[type='application/ld+json']").first.text)
    assert_equal "Event", json.fetch("@type")
    assert_equal "Test Hackathon 2027", json.fetch("name")
    assert_equal "2027-03-06T10:00:00+10:00", json.fetch("startDate")
    assert_equal "Gold Coast · Venue TBA", json.dig("location", "name")
    assert_not json.key?("offers")
  end

  test "show emits an offer while tickets are available" do
    travel_to Time.iso8601(BEFORE_BOTH) do
      get event_path("test-workshop")
    end

    json = JSON.parse(css_select("script[type='application/ld+json']").first.text)
    assert_equal "https://example.com/tickets/test-workshop", json.dig("offers", "url")
    assert_equal "12.50", json.dig("offers", "price")
    assert_equal "https://schema.org/EventScheduled", json.fetch("eventStatus")
  end

  test "homepage features the next event and links to event browsing" do
    travel_to Time.iso8601(BETWEEN) do
      get root_path
    end

    assert_response :success
    assert_select "#events h2", text: "Test Hackathon 2027"
    assert_select "#events a[href='#{event_path('test-hackathon')}']", text: "View event"
    assert_select "a[href='#{events_path}']", text: "All events"
    assert_select "#events img[loading='lazy']", count: 1
  end

  test "homepage falls back to an empty state without upcoming events" do
    travel_to Time.iso8601(AFTER_BOTH) do
      get root_path
    end

    assert_response :success
    assert_select "#events h2", text: "More events coming soon."
    assert_select "#events a[href='#{events_path(anchor: 'past')}']", text: "Browse past events"
  end

  test "event announcement disappears after the event ends" do
    travel_to Time.iso8601(AFTER_BOTH) do
      get root_path
    end

    assert_response :success
    assert_select ".event-announcement", count: 0
  end
end
