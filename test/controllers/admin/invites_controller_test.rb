require "test_helper"

class Admin::InvitesControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as users(:one) }

  test "creates an expiring invitation for the administrator" do
    assert_difference "Invite.count", 1 do
      post admin_invites_path, params: { invite: { email: "new.exec@example.com", role: "exec" } }
    end

    invite = Invite.order(:created_at).last
    assert_equal users(:one), invite.invited_by
    assert_in_delta 1.week.from_now, invite.expires_at, 2.seconds
  end

  test "revokes a pending invitation but preserves an accepted one" do
    pending = invites(:one)
    accepted = invites(:two)

    assert_difference "Invite.count", -1 do
      delete admin_invite_path(pending)
    end

    assert_no_difference "Invite.count" do
      delete admin_invite_path(accepted)
    end
  end
end
