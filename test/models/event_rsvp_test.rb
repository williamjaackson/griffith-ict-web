require "test_helper"

class EventRsvpTest < ActiveSupport::TestCase
  test "accepts and normalizes Griffith student details" do
    rsvp = EventRsvp.create!(
      event_slug: "griffith-ai-hackathon-2026",
      full_name: "  Alex Student  ",
      student_number: " S1234567 ",
      membership_confirmed: true
    )

    assert_equal "Alex Student", rsvp.full_name
    assert_equal "s1234567@griffithuni.edu.au", rsvp.student_email
    assert_equal "s1234567", rsvp.student_number
    assert rsvp.membership_confirmed?
  end

  test "rejects an invalid student number" do
    rsvp = EventRsvp.new(
      event_slug: "griffith-ai-hackathon-2026",
      full_name: "Alex Student",
      student_number: "1234",
      membership_confirmed: true
    )

    assert_not rsvp.valid?
    assert_includes rsvp.errors[:student_number], "must look like s1234567"
    assert_nil rsvp.student_email
  end

  test "requires membership confirmation" do
    rsvp = EventRsvp.new(valid_attributes.merge(membership_confirmed: false))

    assert_not rsvp.valid?
    assert_includes rsvp.errors[:membership_confirmed], "must be accepted"
  end

  test "allows only one RSVP per event for a student number" do
    EventRsvp.create!(valid_attributes)

    duplicate_number = EventRsvp.new(valid_attributes)

    assert_not duplicate_number.valid?
  end

  private

  def valid_attributes
    {
      event_slug: "griffith-ai-hackathon-2026",
      full_name: "Alex Student",
      student_number: "s1234567",
      membership_confirmed: true
    }
  end
end
