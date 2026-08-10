require "test_helper"

class LandingControllerTest < ActionDispatch::IntegrationTest
  test "homepage sends people to Discord for events" do
    get root_path

    assert_response :success
    assert_select "#events h2", text: /It all happens on Discord\./
    assert_select "#events a[href='#{Rails.application.config.socials[:discord]}'][target='_blank']", text: "Join our Discord"
    assert_select "#event-types h3", text: "Hackathons"
    assert_select "#event-types h3", text: "Social Events"
  end

  test "homepage does not link to the event pages" do
    get root_path

    assert_response :success
    assert_select "a[href='#{events_path}']", count: 0
    assert_select ".event-announcement", count: 0
    assert_select "a[href='#events']", text: "View events", count: 1
  end

  test "homepage still renders the community and sponsor sections" do
    get root_path

    assert_response :success
    assert_select "#community h2", text: "Find us everywhere."
    assert_select "#sponsors h2", text: "Backed by industry."
  end
end
