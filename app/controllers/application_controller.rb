class ApplicationController < ActionController::Base
  include Authentication
  allow_browser versions: :modern

  helper_method :current_user

  private

  def current_user
    Current.user
  end

  def require_admin
    redirect_to root_path, alert: "Not authorized." unless Current.user&.admin?
  end
end
