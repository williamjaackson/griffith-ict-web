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

    def chevron_svg(size: "w-3.5 h-3.5", **attrs)
      tag.svg(
        tag.path(d: "M19 9l-7 7-7-7", stroke_linecap: "round", stroke_linejoin: "round"),
        class: "#{size} transition-transform duration-200",
        fill: "none", viewBox: "0 0 24 24", stroke: "currentColor", stroke_width: "2.5",
        **attrs
      )
    end
  end
end
