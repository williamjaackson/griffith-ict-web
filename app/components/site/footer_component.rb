module Site
  class FooterComponent < ViewComponent::Base
    private

    def link_groups
      [
        {
          title: "Club",
          links: [
            { label: "Home", href: helpers.root_path },
            { label: "About", href: helpers.about_path },
            { label: "Community", href: helpers.root_path(anchor: "community") },
            { label: "Sponsors", href: helpers.root_path(anchor: "sponsors") }
          ]
        },
        {
          title: "Resources",
          links: [
            { label: "Sponsorship", href: helpers.sponsorship_path },
            { label: "Perks Program", href: helpers.sponsorship_path(anchor: "perks-program") },
            { label: "Executive Team", href: helpers.about_path(anchor: "team") },
            { label: "Contact Us", href: "mailto:#{socials.fetch(:email)}" }
          ]
        }
      ]
    end

    def socials
      Rails.application.config.socials
    end

    def year
      Date.current.year
    end
  end
end
