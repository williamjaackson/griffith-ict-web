module Ui
  class FooterComponent < ViewComponent::Base
    LINK_GROUPS = [
      {
        title: "Club",
        links: [
          { label: "About", href: "#about" },
          { label: "Events", href: "#events" },
          { label: "Sponsors", href: "#sponsors" }
        ]
      },
      {
        title: "Connect",
        links: [
          { label: "Discord", href: "#" },
          { label: "GitHub", href: "#" },
          { label: "LinkedIn", href: "#" },
          { label: "Instagram", href: "#" }
        ]
      }
    ].freeze

    private

    def link_groups = LINK_GROUPS

    def year
      Date.current.year
    end
  end
end
