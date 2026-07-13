module Site
  class SponsorCardComponent < ViewComponent::Base
    TIER_COLORS = {
      "OPAL" => "var(--color-tier-opal)",
      "AMBER" => "var(--color-tier-amber)",
      "RUBY" => "var(--color-tier-ruby)"
    }.freeze

    def initialize(sponsor: nil)
      @sponsor = sponsor
    end

    private

    attr_reader :sponsor

    def placeholder? = sponsor.nil?
    def name = sponsor.fetch(:name)
    def tier = sponsor.fetch(:tier).upcase
    def logo = sponsor.fetch(:logo)
    def website = sponsor.fetch(:website)
    def tier_color = TIER_COLORS.fetch(tier)
  end
end
