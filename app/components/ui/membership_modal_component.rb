module Ui
  class MembershipModalComponent < ViewComponent::Base
    private

    def discord_url
      Rails.application.config.socials[:discord]
    end

    def gold_coast_url
      Rails.application.config.socials[:campus_groups][:gold_coast]
    end

    def brisbane_url
      Rails.application.config.socials[:campus_groups][:brisbane]
    end
  end
end
