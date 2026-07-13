module Site
  module Navbar
    class Component < ViewComponent::Base
      private

      def links
        [
          { label: "About", href: helpers.about_path, children: [
            { label: "About Us", href: helpers.about_path },
            { label: "Executive Team", href: helpers.about_path(anchor: "team") }
          ] },
          { label: "Events", href: helpers.root_path(anchor: "events") },
          { label: "Community", href: helpers.root_path(anchor: "community") },
          { label: "Sponsors", href: helpers.root_path(anchor: "sponsors"), children: [
            { label: "Our Sponsors", href: helpers.root_path(anchor: "sponsors") },
            { label: "Become a Sponsor", href: helpers.sponsorship_path },
            { label: "Perks Program", href: helpers.sponsorship_path(anchor: "perks-program") }
          ] }
        ]
      end

      def cta = { label: "Become a Member" }
    end
  end
end
