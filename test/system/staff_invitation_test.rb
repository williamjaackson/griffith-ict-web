require "application_system_test_case"

class StaffInvitationTest < ApplicationSystemTestCase
  test "an administrator can invite a new executive" do
    visit new_session_path
    fill_in "Email address", with: users(:one).email_address
    fill_in "Password", with: "password"
    click_on "Sign in"

    visit new_admin_invite_path
    fill_in "Email address", with: "new.exec@example.com"
    select "Exec", from: "Role"

    assert_difference "Invite.count", 1 do
      click_on "Create invite"
      assert_text "Invite created."
    end

    invite = Invite.order(:created_at).last
    visit accept_invite_path(invite.token)
    fill_in "Password", with: "new-password"
    fill_in "Confirm password", with: "new-password"

    assert_difference "User.count", 1 do
      click_on "Create account"
      assert_text "Welcome! Your account has been created."
    end

    assert_equal "exec", User.find_by!(email_address: "new.exec@example.com").role
  end
end
