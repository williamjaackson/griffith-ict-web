require "test_helper"

class PublicPagesControllerTest < ActionDispatch::IntegrationTest
  test "renders the landing page for guests" do
    get root_path

    assert_response :success
    assert_select "h2", text: /Build\. Learn\./
    assert_select "section#sponsors"
    assert_select "body[data-controller~='modal']"
    assert_select "nav[aria-label='Primary']"
    assert_select "button[aria-controls='mobile-navigation'][aria-expanded='false']"
    assert_select "#mobile-navigation[aria-hidden='true'][inert]"
    assert_select "[data-controller='dropdown'] [data-dropdown-target='trigger'][aria-expanded='false']", minimum: 1
    assert_select "[data-dropdown-target='menu'][aria-hidden='true'][inert]", minimum: 1
    assert_select "#membership-modal[aria-hidden='true'][inert] [role='dialog'][aria-modal='true']"
    assert_select "#perk-modal[aria-hidden='true'][inert] [role='dialog'][aria-modal='true']"
    assert_select "[onclick]", count: 0
    assert_select "[style]", count: 0
    assert_select "style", count: 0

    policy = response.headers.fetch("Content-Security-Policy")
    assert_includes policy, "default-src 'self'"
    assert_includes policy, "frame-ancestors 'none'"
    assert_match(/script-src 'self' 'nonce-[^']+'/, policy)
    assert_select "script[nonce]", minimum: 1
  end

  test "renders the about page and configured team" do
    get about_path

    assert_response :success
    assert_select "h1", text: /Meet/
    assert_select "section#team"
    assert_select "button", text: /Gold Coast/
    assert_select "[role='tablist'][aria-label='Campus']"
    assert_select "button[role='tab'][aria-selected='true'][tabindex='0']", count: 1
    assert_select "button[role='tab'][aria-selected='false'][tabindex='-1']", minimum: 1
    assert_select "[role='tabpanel'][aria-labelledby]", count: 2
    assert_select "[role='tabpanel'][hidden]", count: 1
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
