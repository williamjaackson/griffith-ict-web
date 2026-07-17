require "application_system_test_case"

class VisitorFlowsTest < ApplicationSystemTestCase
  test "a visitor can join and RSVP for an event" do
    visit root_path

    within ".site-navbar" do
      click_on "Become a member", match: :first
    end

    within "#membership-dialog" do
      assert_link "Open Discord", href: Rails.application.config.socials[:discord]
      click_on "Continue"
      assert_link "Gold Coast", href: Rails.application.config.socials.dig(:campus_groups, :gold_coast)
    end

    visit event_path("griffith-ai-hackathon-2026")
    click_on "RSVP now"

    assert_difference "EventRsvp.count", 1 do
      within "#event-rsvp-dialog" do
        fill_in "Full name", with: "Alex Student"
        fill_in "Student number", with: "s7654321"
        check "I am a member of the Griffith ICT Club."
        click_on "Record my RSVP"
      end
    end

    assert_text "Your RSVP has been recorded."
    assert_equal "s7654321@griffithuni.edu.au", EventRsvp.order(:created_at).last.student_email
  end
end
