class SponsorshipController < ApplicationController
  allow_unauthenticated_access

  def show
    @tiers = Rails.application.config.site.fetch(:sponsorship_tiers).fetch(:tiers)
  end
end
