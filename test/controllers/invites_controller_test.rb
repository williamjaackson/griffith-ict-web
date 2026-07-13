require "test_helper"

class InvitesControllerTest < ActionDispatch::IntegrationTest
  test "renders a pending invite" do
    invite = invites(:pending)

    get accept_invite_path(token: invite.token)

    assert_response :success
    assert_select "title", text: "Create Account | Griffith ICT Club"
    assert_select "meta[name=robots][content='noindex, nofollow']"
    assert_select "input[type=email][value='#{invite.email}'][disabled]"
    assert_select "label[for=invited_email]", text: "Email address"
    assert_select "label[for=account_password]", text: "Password"
    assert_select "label[for=account_password_confirmation]", text: "Confirm password"
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
      post complete_invite_path(token: invite.token), params: { account: {
        password: "secure-password",
        password_confirmation: "secure-password"
      } }
    end

    assert_redirected_to root_path
    assert cookies[:session_id]
    assert invite.reload.accepted?
    assert_equal invite.role, User.find_by!(email_address: invite.email).role
  end

  test "does not consume an invite when account creation fails" do
    invite = invites(:pending)

    assert_no_difference([ "User.count", "Session.count" ]) do
      post complete_invite_path(token: invite.token), params: { account: {
        password: "one-password",
        password_confirmation: "different-password"
      } }
    end

    assert_response :unprocessable_entity
    assert_not invite.reload.accepted?
    assert_select "p", text: /Password confirmation/
  end
end
