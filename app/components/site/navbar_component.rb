module Site
  class NavbarComponent < ViewComponent::Base
    private

    def links
      [
        {
          label: "About",
          children: [
            [ "About us", helpers.about_path ],
            [ "Executive team", "#{helpers.about_path}#team" ]
          ]
        },
        { label: "Events", href: helpers.events_path },
        { label: "Community", href: "#{helpers.root_path}#community" },
        {
          label: "Sponsors",
          children: [
            [ "Our sponsors", "#{helpers.root_path}#sponsors" ],
            [ "Become a sponsor", helpers.sponsorship_path ],
            [ "Perks program", "#{helpers.sponsorship_path}#perks-program" ]
          ]
        }
      ]
    end

    def featured_event = EventCatalog.upcoming.first
  end
end
