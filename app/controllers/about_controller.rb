class AboutController < ApplicationController
  allow_unauthenticated_access

  def show
    team = Rails.application.config.site.fetch(:team)
    @campuses = team.fetch(:campuses)
    @team_roles = team.fetch(:roles)
  end
end
