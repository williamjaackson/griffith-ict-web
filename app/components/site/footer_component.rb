module Site
  class FooterComponent < ViewComponent::Base
    private

    def link_groups
      [
        {
          title: "Club",
          links: [
            [ "Home", helpers.root_path ],
            [ "About", helpers.about_path ],
            [ "Events", helpers.events_path ],
            [ "Community", "#{helpers.root_path}#community" ],
            [ "Sponsors", "#{helpers.root_path}#sponsors" ]
          ]
        },
        {
          title: "Resources",
          links: [
            [ "Sponsorship", helpers.sponsorship_path ],
            [ "Perks Program", "#{helpers.sponsorship_path}#perks-program" ],
            [ "Executive Team", "#{helpers.about_path}#team" ],
            [ "Contact Us", "mailto:#{socials[:email]}" ]
          ]
        }
      ]
    end

    def socials
      Rails.application.config.socials
    end

    def year = Date.current.year
  end
end
