module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :authenticated?
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private
    def authenticated?
      resume_session
    end

    def require_authentication
      resume_session || request_authentication
    end

    def resume_session
      Current.session ||= find_session_by_cookie
    end

    def find_session_by_cookie
      session_id = cookies.signed[:session_id]
      Session.active.find_by(id: session_id) if session_id
    end

    def request_authentication
      session[:return_to_after_authenticating] = request.fullpath if request.get? || request.head?
      redirect_to new_session_path
    end

    def after_authentication_url
      url_from(session.delete(:return_to_after_authenticating)) || root_path
    end

    def start_new_session_for(user)
      user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
        Current.session = session
        cookies.signed[:session_id] = {
          value: session.id,
          expires: Session::LIFETIME.from_now,
          httponly: true,
          same_site: :lax,
          secure: Rails.env.production?
        }
      end
    end

    def terminate_session
      Current.session&.destroy!
      cookies.delete(:session_id)
    end
end
