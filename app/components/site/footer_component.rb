module Site
  class FooterComponent < ViewComponent::Base
    LINK_GROUPS = [
      {
        title: "Club",
        links: [
          { label: "Home", href: "/" },
          { label: "About", href: "/about#" },
          { label: "Events", href: "#events" },
          { label: "Sponsors", href: "#sponsors" }
        ]
      },
      {
        title: "Resources",
        links: [
          { label: "Sponsorship", href: "/sponsorship" },
          { label: "Design System", href: "/design_system" }
        ]
      }
    ].freeze

    private

    def link_groups = LINK_GROUPS

    def socials
      Rails.application.config.socials
    end

    def year
      Date.current.year
    end
  end
end
