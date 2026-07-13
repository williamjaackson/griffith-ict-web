require "test_helper"

class PublicPagesControllerTest < ActionDispatch::IntegrationTest
  test "renders the landing page for guests" do
    get root_path

    assert_response :success
    assert_select "h2", text: /Build\. Learn\./
    assert_select "section#sponsors"
    assert_select "body[data-controller~='modal']"
    assert_select "#membership-modal[aria-hidden='true'][inert] [role='dialog'][aria-modal='true']"
    assert_select "#perk-modal[aria-hidden='true'][inert] [role='dialog'][aria-modal='true']"
    assert_select "[onclick]", count: 0
  end

  test "renders the about page and configured team" do
    get about_path

    assert_response :success
    assert_select "h1", text: /Meet/
    assert_select "section#team"
    assert_select "button", text: /Gold Coast/
    assert_select "#role-modal[aria-hidden='true'][inert] [role='dialog'][aria-modal='true']"
  end

  test "renders the sponsorship page and every configured tier" do
    get sponsorship_path

    assert_response :success
    Rails.application.config.site.dig(:sponsorship_tiers, :tiers).each do |tier|
      assert_select ".badge", text: tier.fetch(:name).upcase
    end
  end

  test "renders the health check" do
    get rails_health_check_path

    assert_response :success
  end
end
