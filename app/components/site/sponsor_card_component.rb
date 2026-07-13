module Site
  class SponsorCardComponent < ViewComponent::Base
    TIER_CLASSES = {
      "OPAL" => "!bg-tier-opal",
      "AMBER" => "!bg-tier-amber",
      "RUBY" => "!bg-tier-ruby"
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
    def tier_class = TIER_CLASSES.fetch(tier)
  end
end
