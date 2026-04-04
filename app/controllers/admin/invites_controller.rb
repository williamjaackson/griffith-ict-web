module Admin
  class InvitesController < ApplicationController
    before_action :require_admin

    def index
      @invites = Invite.order(created_at: :desc)
    end

    def new
      @invite = Invite.new
    end

    def create
      @invite = Invite.new(invite_params)
      @invite.invited_by = Current.user
      @invite.expires_at = 7.days.from_now

      if @invite.save
        redirect_to admin_invites_path, notice: "Invite created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      invite = Invite.find(params[:id])
      invite.destroy
      redirect_to admin_invites_path, notice: "Invite revoked.", status: :see_other
    end

    private

    def invite_params
      params.require(:invite).permit(:email, :role)
    end
  end
end
