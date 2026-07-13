require "test_helper"

class InvitesControllerTest < ActionDispatch::IntegrationTest
  test "renders a pending invite" do
    invite = invites(:pending)

    get accept_invite_path(token: invite.token)

    assert_response :success
    assert_select "input[type=email][value='#{invite.email}'][disabled]"
  end

  test "rejects an expired invite" do
    get accept_invite_path(token: invites(:expired).token)

    assert_redirected_to root_path
    assert_equal "This invite is invalid or has expired.", flash[:alert]
  end

  test "rejects an accepted invite" do
    get accept_invite_path(token: invites(:accepted).token)

    assert_redirected_to root_path
    assert_equal "This invite is invalid or has expired.", flash[:alert]
  end

  test "completes an invite atomically and signs in the new user" do
    invite = invites(:pending)

    assert_difference([ "User.count", "Session.count" ], 1) do
      post complete_invite_path(token: invite.token), params: {
        password: "secure-password",
        password_confirmation: "secure-password"
      }
    end

    assert_redirected_to root_path
    assert cookies[:session_id]
    assert invite.reload.accepted?
    assert_equal invite.role, User.find_by!(email_address: invite.email).role
  end

  test "does not consume an invite when account creation fails" do
    invite = invites(:pending)

    assert_no_difference([ "User.count", "Session.count" ]) do
      post complete_invite_path(token: invite.token), params: {
        password: "one-password",
        password_confirmation: "different-password"
      }
    end

    assert_response :unprocessable_entity
    assert_not invite.reload.accepted?
    assert_select "p", text: /Password confirmation/
  end
end
