require "test_helper"

class PublicPagesControllerTest < ActionDispatch::IntegrationTest
  test "renders the landing page for guests" do
    get root_path

    assert_response :success
    assert_select "h2", text: /Build\. Learn\./
    assert_select "section#sponsors"
  end

  test "renders the about page and configured team" do
    get about_path

    assert_response :success
    assert_select "h1", text: /Meet/
    assert_select "section#team"
    assert_select "button", text: /Gold Coast/
  end

  test "renders the sponsorship page and every configured tier" do
    get sponsorship_path

    assert_response :success
    YAML.safe_load_file(Rails.root.join("config/sponsorship_tiers.yml")).fetch("tiers").each do |tier|
      assert_select ".badge", text: tier.fetch("name").upcase
    end
  end

  test "renders the health check" do
    get rails_health_check_path

    assert_response :success
  end
end
