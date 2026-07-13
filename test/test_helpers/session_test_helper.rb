module SessionTestHelper
  def sign_in_as(user)
    Current.session = user.sessions.create!

    sign_in_with_session(Current.session)
  end

  def sign_in_with_session(session_record)
    ActionDispatch::TestRequest.create.cookie_jar.tap do |cookie_jar|
      cookie_jar.signed[:session_id] = session_record.id
      cookies["session_id"] = cookie_jar[:session_id]
    end
  end

  def sign_out
    Current.session&.destroy!
    cookies.delete("session_id")
  end
end

ActiveSupport.on_load(:action_dispatch_integration_test) do
  include SessionTestHelper
end
