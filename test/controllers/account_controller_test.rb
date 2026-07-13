require "test_helper"

class AccountControllerTest < ActionDispatch::IntegrationTest
  test "redirects guests to sign in" do
    get account_path

    assert_redirected_to new_session_path
  end

  test "renders the signed-in account" do
    user = users(:executive)
    sign_in_as(user)

    get account_path

    assert_response :success
    assert_select "h1", text: /account/
    assert_select "p", text: /#{Regexp.escape(user.email_address)}/
  end

  test "shows invite management only to administrators" do
    sign_in_as(users(:admin))

    get account_path

    assert_response :success
    assert_select "a[href='#{admin_invites_path}']", text: /Manage invites/
  end
end
