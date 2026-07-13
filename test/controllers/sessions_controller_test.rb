require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup { @user = users(:executive) }

  test "new" do
    get new_session_path
    assert_response :success
  end

  test "create with valid credentials" do
    assert_difference("Session.count", 1) do
      post session_path, params: { email_address: @user.email_address, password: "password" }
    end

    assert_redirected_to root_path
    assert cookies[:session_id]
  end

  test "normalizes email credentials" do
    post session_path, params: {
      email_address: "  #{ @user.email_address.upcase }  ",
      password: "password"
    }

    assert_redirected_to root_path
    assert cookies[:session_id]
  end

  test "returns to the requested page after authentication" do
    get account_path
    assert_redirected_to new_session_path

    post session_path, params: { email_address: @user.email_address, password: "password" }

    assert_redirected_to account_path
  end

  test "create with invalid credentials" do
    post session_path, params: { email_address: @user.email_address, password: "wrong" }

    assert_redirected_to new_session_path
    assert_nil cookies[:session_id]
  end

  test "destroy" do
    sign_in_as(@user)

    assert_difference("Session.count", -1) { delete session_path }

    assert_redirected_to new_session_path
    assert_empty cookies[:session_id]
  end

  test "does not resume an expired session" do
    expired_session = @user.sessions.create!(created_at: Session::LIFETIME.ago - 1.second)
    sign_in_with_session(expired_session)

    get account_path

    assert_redirected_to new_session_path
  end
end
