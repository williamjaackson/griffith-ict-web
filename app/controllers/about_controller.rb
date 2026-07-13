class AboutController < ApplicationController
  allow_unauthenticated_access

  def show
    team_config = YAML.load_file(Rails.root.join("config/team.yml"))
    @team = team_config["campuses"]
    @team_roles = team_config["roles"]
  end
end
