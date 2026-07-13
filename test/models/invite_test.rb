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

  test "requires an expiration" do
    invite = Invite.new(email: "expiration@example.com", role: :exec,
      invited_by: users(:admin))

    assert_not invite.valid?
    assert_includes invite.errors[:expires_at], "can't be blank"
  end

  test "normalizes email addresses" do
    invite = Invite.new(email: " NEW@EXAMPLE.COM ")

    assert_equal "new@example.com", invite.email
  end

  test "does not invite an existing user" do
    invite = build_invite(email: users(:executive).email_address)

    assert_not invite.valid?
    assert_includes invite.errors[:email], "already belongs to an account"
  end

  test "does not duplicate a pending invite" do
    invite = build_invite(email: invites(:pending).email)

    assert_not invite.valid?
    assert_includes invite.errors[:email], "already has a pending invite"
  end

  test "allows a replacement for an expired invite" do
    assert_predicate build_invite(email: invites(:expired).email), :valid?
  end

  test "pending only includes unaccepted, unexpired invites" do
    assert_equal [ invites(:pending) ], Invite.pending.to_a
  end

  test "reports accepted and expired states" do
    assert_predicate invites(:accepted), :accepted?
    assert_not_predicate invites(:pending), :accepted?
    assert_predicate invites(:expired), :expired?
    assert_not_predicate invites(:pending), :expired?
    assert_predicate invites(:pending), :pending?
    assert_not_predicate invites(:expired), :pending?
  end

  test "accepts a pending invite and persists the user atomically" do
    invite = invites(:pending)

    user = nil
    assert_difference("User.count", 1) do
      user = invite.accept!(password: "password", password_confirmation: "password")
    end

    assert_predicate invite.reload, :accepted?
    assert_equal invite.email, user.email_address
    assert_equal invite.role, user.role
  end

  test "does not accept an unavailable invite" do
    invite = invites(:accepted)

    assert_no_difference("User.count") do
      assert_raises(Invite::Unavailable) do
        invite.accept!(password: "password", password_confirmation: "password")
      end
    end
  end

  private

  def build_invite(email:)
    Invite.new(email: email, role: :exec,
      expires_at: Invite::LIFETIME.from_now, invited_by: users(:admin))
  end
end
