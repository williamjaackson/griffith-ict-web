require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  test "published events remain discoverable before and after they run" do
    get events_path

    assert_response :success
    assert_select "a[href='#{event_path("griffith-ai-hackathon-2026")}']", minimum: 1

    travel_to Time.iso8601("2026-08-02T10:00:00+10:00") do
      get events_path

      assert_response :success
      assert_select "a[href='#{event_path("griffith-ai-hackathon-2026")}']", minimum: 1
    end
  end

  test "an event can be viewed and unknown events return not found" do
    get event_path("griffith-ai-hackathon-2026")

    assert_response :success
    assert_select "form[action='#{event_rsvp_path("griffith-ai-hackathon-2026")}']"

    get event_path("not-an-event")

    assert_response :not_found
  end

  test "an RSVP is recorded with its derived student email" do
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
  end

  test "membership confirmation is required" do
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
  end

  test "completed events remain available but reject RSVPs" do
    travel_to Time.iso8601("2026-08-02T10:00:00+10:00") do
      get event_path("griffith-ai-hackathon-2026")

      assert_response :success
      assert_select "form[action='#{event_rsvp_path("griffith-ai-hackathon-2026")}']", count: 0

      assert_no_difference "EventRsvp.count" do
        post event_rsvp_path("griffith-ai-hackathon-2026"), params: {
          event_rsvp: {
            full_name: "Alex Student",
            student_number: "s1234567",
            membership_confirmed: "1"
          }
        }
      end

      assert_redirected_to event_path("griffith-ai-hackathon-2026")
    end
  end

  test "event pages publish canonical metadata and structured data" do
    get event_path("griffith-ai-hackathon-2026")

    assert_select "title", text: "Griffith AI-Hackathon 2026 | Griffith ICT Club"
    assert_select "link[rel='canonical'][href='https://griffithict.club/events/griffith-ai-hackathon-2026']"

    event_data = JSON.parse(css_select("script[type='application/ld+json']").first.text)
    assert_equal "Event", event_data.fetch("@type")
    assert_equal "2026-08-01T10:00:00+10:00", event_data.fetch("startDate")
    assert_not event_data.key?("offers")
  end

  test "the homepage links to the next event" do
    get root_path

    assert_response :success
    assert_select "a[href='#{event_path("griffith-ai-hackathon-2026")}']", minimum: 1
    assert_select "a[href='#{events_path}']", minimum: 1
  end
end
