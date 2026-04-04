class InvitesController < ApplicationController
  allow_unauthenticated_access

  before_action :set_invite

  def accept
    if request.post?
      user = User.new(
        email_address: @invite.email,
        role: @invite.role,
        password: params[:password],
        password_confirmation: params[:password_confirmation]
      )

      if user.save
        @invite.update!(accepted_at: Time.current)
        start_new_session_for(user)
        redirect_to root_path, notice: "Welcome! Your account has been created."
      else
        @errors = user.errors
        render :accept, status: :unprocessable_entity
      end
    end
  end

  private

  def set_invite
    @invite = Invite.pending.find_by!(token: params[:token])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "This invite is invalid or has expired."
  end
end
