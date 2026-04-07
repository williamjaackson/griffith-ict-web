class SponsorshipController < ApplicationController
  allow_unauthenticated_access

  def show
    @tiers = YAML.load_file(Rails.root.join("config/sponsorship_tiers.yml"))["tiers"]
  end
end
