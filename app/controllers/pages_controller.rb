class PagesController < ApplicationController
  def home
    render "pages/landing/home"
  end

  def design_system
  end

  def about
    @team = YAML.load_file(Rails.root.join("config/team.yml"))["campuses"]
    render "pages/about/about"
  end

  def sponsorship
    @tiers = YAML.load_file(Rails.root.join("config/sponsorship_tiers.yml"))["tiers"]
    render "pages/sponsorship/sponsorship"
  end
end
