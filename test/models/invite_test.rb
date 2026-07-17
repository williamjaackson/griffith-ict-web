require "test_helper"

class InviteTest < ActiveSupport::TestCase
  test "accepting an invite creates the user and records acceptance" do
    invite = Invite.create!(email: "invited@example.com", role: :exec, invited_by: users(:one), expires_at: 1.week.from_now)

    assert_difference "User.count", 1 do
      user = invite.accept!(password: "password", password_confirmation: "password")

      assert_equal invite.email, user.email_address
      assert_equal invite.role, user.role
    end

    assert invite.reload.accepted?
  end

  test "failed acceptance rolls back both records" do
    invite = Invite.create!(email: "invited@example.com", role: :exec, invited_by: users(:one), expires_at: 1.week.from_now)

    assert_no_difference "User.count" do
      assert_raises ActiveRecord::RecordInvalid do
        invite.accept!(password: "password", password_confirmation: "different")
      end
    end

    assert_not invite.reload.accepted?
  end

  test "pending excludes accepted and expired invites" do
    pending = Invite.create!(email: "pending@example.com", role: :exec, invited_by: users(:one), expires_at: 1.week.from_now)
    expired = Invite.create!(email: "expired@example.com", role: :exec, invited_by: users(:one), expires_at: 1.minute.ago)

    assert_includes Invite.pending, pending
    assert_not_includes Invite.pending, expired
    assert expired.expired?
  end

  test "an expired invite cannot be accepted" do
    invite = Invite.create!(email: "late@example.com", role: :exec, invited_by: users(:one), expires_at: 1.minute.ago)

    assert_no_difference "User.count" do
      assert_raises ActiveRecord::RecordInvalid do
        invite.accept!(password: "password", password_confirmation: "password")
      end
    end
  end
end
