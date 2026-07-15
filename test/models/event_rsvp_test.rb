require "test_helper"

class EventRsvpTest < ActiveSupport::TestCase
  test "accepts and normalizes Griffith student details" do
    rsvp = EventRsvp.create!(
      event_slug: "griffith-ai-hackathon-2026",
      full_name: "  Alex Student  ",
      student_email: "  ALEX.STUDENT@GRIFFITHUNI.EDU.AU ",
      student_number: " S1234567 "
    )

    assert_equal "Alex Student", rsvp.full_name
    assert_equal "alex.student@griffithuni.edu.au", rsvp.student_email
    assert_equal "s1234567", rsvp.student_number
  end

  test "rejects non-student email and invalid student number" do
    rsvp = EventRsvp.new(
      event_slug: "griffith-ai-hackathon-2026",
      full_name: "Alex Student",
      student_email: "alex@example.com",
      student_number: "1234"
    )

    assert_not rsvp.valid?
    assert_includes rsvp.errors[:student_email], "must be a Griffith student email ending in @griffithuni.edu.au"
    assert_includes rsvp.errors[:student_number], "must start with s followed by 6 to 8 digits"
  end

  test "allows only one RSVP per event for an email or student number" do
    EventRsvp.create!(valid_attributes)

    duplicate_email = EventRsvp.new(valid_attributes.merge(student_number: "s7654321"))
    duplicate_number = EventRsvp.new(valid_attributes.merge(student_email: "another.student@griffithuni.edu.au"))

    assert_not duplicate_email.valid?
    assert_not duplicate_number.valid?
  end

  private

  def valid_attributes
    {
      event_slug: "griffith-ai-hackathon-2026",
      full_name: "Alex Student",
      student_email: "alex.student@griffithuni.edu.au",
      student_number: "s1234567"
    }
  end
end
