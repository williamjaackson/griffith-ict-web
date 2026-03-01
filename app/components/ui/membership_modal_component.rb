module Ui
  class MembershipModalComponent < ViewComponent::Base
    CAMPUS_GROUPS = {
      gold_coast: "https://griffith.campusgroups.com/GIC/club_signup",
      brisbane: "https://griffith.campusgroups.com/GICT/club_signup"
    }.freeze

    private

    def discord_url
      Rails.application.config.socials[:discord]
    end

    def gold_coast_url
      CAMPUS_GROUPS[:gold_coast]
    end

    def brisbane_url
      CAMPUS_GROUPS[:brisbane]
    end
  end
end
