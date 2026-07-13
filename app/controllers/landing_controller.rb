class LandingController < ApplicationController
  allow_unauthenticated_access

  def show
    sponsors = Rails.application.config.site.fetch(:sponsors)
    @sponsors = sponsors.fetch(:sponsors, [])
    @perks = sponsors.fetch(:perks, [])
  end
end
