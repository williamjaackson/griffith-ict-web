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

    def chevron_svg(css_class:, **attrs)
      tag.svg(
        tag.path(d: "M19 9l-7 7-7-7", stroke_linecap: "round", stroke_linejoin: "round"),
        class: css_class, fill: "none", viewBox: "0 0 24 24", stroke: "currentColor", stroke_width: "2.5", **attrs
      )
    end

    def underline_span
      tag.span(class: "absolute -bottom-1 left-1/2 w-0 h-0.5 bg-brand-red transition-all duration-300 group-hover:w-full group-hover:left-0")
    end
  end
end
