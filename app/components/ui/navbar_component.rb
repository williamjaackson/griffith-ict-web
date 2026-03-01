module Ui
  class NavbarComponent < ViewComponent::Base
    LINKS = [
      { label: "About", href: "/#about" },
      { label: "Events", href: "/#events" },
      { label: "Community", href: "/#community" },
      { label: "Sponsors", href: "/#sponsors", children: [
        { label: "Our Sponsors", href: "/#sponsors" },
        { label: "Become a Sponsor", href: "/sponsorship" }
      ] }
    ].freeze

    CTA = { label: "Join Us", href: "/#community" }.freeze

    private

    def links = LINKS
    def cta = CTA
  end
end
