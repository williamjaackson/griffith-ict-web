class InvitesController < ApplicationController
  allow_unauthenticated_access

  before_action :set_invite

  def accept
  end

  def complete
    user = @invite.accept!(**password_params)
    start_new_session_for(user)
    redirect_to root_path, notice: "Welcome! Your account has been created."
  rescue ActiveRecord::RecordInvalid => error
    @errors = error.record.errors
    render :accept, status: :unprocessable_entity
  end

  private

  def set_invite
    @invite = Invite.pending.find_by!(token: params[:token])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "This invite is invalid or has expired."
  end

  def password_params
    params.permit(:password, :password_confirmation).to_h.symbolize_keys
  end
end
