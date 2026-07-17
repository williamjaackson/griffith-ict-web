module Site
  class MembershipDialogComponent < ViewComponent::Base
    private

    def socials = Rails.application.config.socials
  end
end
