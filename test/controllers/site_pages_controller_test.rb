require "test_helper"

class SitePagesControllerTest < ActionDispatch::IntegrationTest
  test "public pages are available without an account" do
    [ root_path, about_path, sponsorship_path, events_path ].each do |path|
      get path

      assert_response :success, "Expected #{path} to be public"
    end
  end

  test "staff pages require an account and admin authority" do
    get admin_invites_path
    assert_redirected_to new_session_path

    sign_in_as users(:two)
    get admin_invites_path
    assert_redirected_to root_path

    sign_in_as users(:one)
    get admin_invites_path
    assert_response :success
  end
end
