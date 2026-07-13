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

  test "destroys sessions with the user" do
    user = users(:executive)
    user.sessions.create!

    assert_difference("Session.count", -1) { user.destroy! }
  end
end
