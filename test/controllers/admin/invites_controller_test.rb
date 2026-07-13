require "test_helper"

module Admin
  class InvitesControllerTest < ActionDispatch::IntegrationTest
    test "redirects guests to sign in" do
      get admin_invites_path

      assert_redirected_to new_session_path
    end

    test "rejects non-admin users" do
      sign_in_as(users(:executive))

      get admin_invites_path

      assert_redirected_to root_path
      assert_equal "Not authorized.", flash[:alert]
    end

    test "renders the invite list for administrators" do
      sign_in_as(users(:admin))

      get admin_invites_path

      assert_response :success
      assert_select "h1", text: "Invites"
      assert_select "[data-controller=clipboard]", minimum: 1
      assert_select "button[data-clipboard-target=button][aria-live=polite]", minimum: 1
      assert_select "form[data-controller=confirm][data-action='submit->confirm#check']", minimum: 1
    end

    test "renders a natively accessible invite form" do
      sign_in_as(users(:admin))

      get new_admin_invite_path

      assert_response :success
      assert_select "label[for=invite_email]", text: "Email address"
      assert_select "label[for=invite_role]", text: "Role"
      assert_select "select#invite_role[name='invite[role]'] option", count: Invite.roles.length
      assert_select "[data-controller=select]", count: 0
    end

    test "creates an invite attributed to the administrator" do
      admin = users(:admin)
      sign_in_as(admin)

      assert_difference("Invite.count", 1) do
        post admin_invites_path, params: {
          invite: { email: "new-executive@example.com", role: "exec" }
        }
      end

      invite = Invite.order(:created_at).last
      assert_redirected_to admin_invites_path
      assert_equal admin, invite.invited_by
      assert_equal "exec", invite.role
      assert_in_delta 7.days.from_now, invite.expires_at, 2.seconds
    end

    test "renders validation errors without creating an invite" do
      sign_in_as(users(:admin))

      assert_no_difference("Invite.count") do
        post admin_invites_path, params: { invite: { email: "invalid", role: "exec" } }
      end

      assert_response :unprocessable_entity
      assert_select "p", text: /Email is invalid/
    end

    test "rejects an unsupported role without an exception" do
      sign_in_as(users(:admin))

      assert_no_difference("Invite.count") do
        post admin_invites_path, params: {
          invite: { email: "invalid-role@example.com", role: "unsupported" }
        }
      end

      assert_response :unprocessable_entity
      assert_select "p", text: /Role is not included/
    end

    test "revokes a pending invite" do
      sign_in_as(users(:admin))
      invite = invites(:pending)

      assert_difference("Invite.count", -1) do
        delete admin_invite_path(invite)
      end

      assert_redirected_to admin_invites_path
    end

    test "does not revoke an accepted invite" do
      sign_in_as(users(:admin))
      invite = invites(:accepted)

      assert_no_difference("Invite.count") do
        delete admin_invite_path(invite)
      end

      assert_redirected_to admin_invites_path
      assert_equal "Accepted invites cannot be revoked.", flash[:alert]
    end
  end
end
