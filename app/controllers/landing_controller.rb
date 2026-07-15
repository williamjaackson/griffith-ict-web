class LandingController < ApplicationController
  allow_unauthenticated_access

  def show
    config = YAML.load_file(Rails.root.join("config/sponsors.yml"))
    @sponsors = config["sponsors"] || []
    @perks = config["perks"] || []
    @next_event = EventCatalog.upcoming.first
  end
end
