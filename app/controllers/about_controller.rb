class AboutController < ApplicationController
  allow_unauthenticated_access

  def show
    @team = YAML.load_file(Rails.root.join("config/team.yml"))["campuses"]
  end
end
