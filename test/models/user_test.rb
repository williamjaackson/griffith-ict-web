require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", user.email_address)
  end

  test "requires a valid unique email address" do
    user = User.new(email_address: "not-an-email", password: "password")

    assert_not user.valid?
    assert_includes user.errors[:email_address], "is invalid"

    duplicate = User.new(email_address: users(:admin).email_address, password: "password")
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:email_address], "has already been taken"
  end

  test "requires passwords to be at least eight characters" do
    user = User.new(email_address: "short-password@example.com", password: "short")

    assert_not user.valid?
    assert_includes user.errors[:password], "is too short (minimum is 8 characters)"
  end

  test "authenticates normalized email credentials" do
    user = users(:admin)

    assert_equal user, User.authenticate(email_address: " #{user.email_address.upcase} ", password: "password")
    assert_nil User.authenticate(email_address: user.email_address, password: "incorrect")
  end

  test "rejects unsupported roles without raising" do
    user = User.new(email_address: "role@example.com", password: "password", role: "unsupported")

    assert_not user.valid?
    assert_includes user.errors[:role], "is not included in the list"
  end

  test "destroys sessions with the user" do
    user = users(:executive)
    user.sessions.create!

    assert_difference("Session.count", -1) { user.destroy! }
  end

  test "does not destroy an invite creator" do
    user = users(:admin)

    assert_no_difference("User.count") { assert_not user.destroy }
    assert_includes user.errors[:base], "Cannot delete record because dependent invites exist"
  end
end
