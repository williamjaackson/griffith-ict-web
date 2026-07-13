class InvitesController < ApplicationController
  allow_unauthenticated_access

  before_action :set_invite

  def accept
  end

  def complete
    user = @invite.accept!(**passwords)

    start_new_session_for(user)
    redirect_to root_path, notice: "Welcome! Your account has been created."
  rescue ActiveRecord::RecordInvalid => error
    @errors = error.record.errors
    render :accept, status: :unprocessable_entity
  rescue Invite::Unavailable
    redirect_to root_path, alert: "This invite is invalid or has expired."
  end

  private

  def passwords
    params.permit(:password, :password_confirmation).to_h.symbolize_keys
  end

  def set_invite
    @invite = Invite.pending.find_by!(token: params[:token])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "This invite is invalid or has expired."
  end
end
