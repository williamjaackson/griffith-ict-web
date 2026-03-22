module Site
  module Navbar
    class Component < ViewComponent::Base
      LINKS = [
        { label: "About", href: "/about#", children: [
          { label: "About Us", href: "/about#" },
          { label: "Executive Team", href: "/about#team" }
        ] },
        { label: "Events", href: "/#events" },
        { label: "Community", href: "/#community" },
        { label: "Sponsors", href: "/#sponsors", children: [
          { label: "Our Sponsors", href: "/#sponsors" },
          { label: "Become a Sponsor", href: "/sponsorship#" },
          { label: "Perks Program", href: "/sponsorship#perks-program" }
        ] }
      ].freeze

      CTA = { label: "Become a Member" }.freeze

      private

      def links = LINKS
      def cta = CTA
    end
  end
end
