require "test_helper"

class InviteTest < ActiveSupport::TestCase
  test "generates a unique token when created" do
    invite = Invite.create!(email: "new@example.com", role: :exec,
      expires_at: 1.day.from_now, invited_by: users(:admin))

    assert invite.token.present?
    assert_equal 43, invite.token.length
  end

  test "requires a valid email address" do
    invite = Invite.new(email: "invalid", role: :exec,
      expires_at: 1.day.from_now, invited_by: users(:admin))

    assert_not invite.valid?
    assert_includes invite.errors[:email], "is invalid"
  end

  test "pending only includes unaccepted, unexpired invites" do
    assert_equal [ invites(:pending) ], Invite.pending.to_a
  end

  test "reports accepted and expired states" do
    assert_predicate invites(:accepted), :accepted?
    assert_not_predicate invites(:pending), :accepted?
    assert_predicate invites(:expired), :expired?
    assert_not_predicate invites(:pending), :expired?
  end
end
