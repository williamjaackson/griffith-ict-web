module Site
  class SponsorshipTierComponent < ViewComponent::Base
    TIER_CLASSES = {
      "opal" => { background: "!bg-tier-opal", text: "text-tier-opal" },
      "amber" => { background: "!bg-tier-amber", text: "text-tier-amber" },
      "ruby" => { background: "!bg-tier-ruby", text: "text-tier-ruby" }
    }.freeze

    def initialize(tier:, inherited_tiers: [])
      @tier = tier
      @inherited_tiers = inherited_tiers
    end

    private

    attr_reader :tier, :inherited_tiers

    def perks
      inherited_perks + tier.fetch(:perks).map { |label| { label: label, tier: tier_key } }
    end

    def inherited_perks
      inherited_tiers.flat_map do |inherited|
        key = inherited.fetch(:name).downcase
        inherited.fetch(:perks).map { |label| { label: label, tier: key } }
      end
    end

    def tier_key = tier.fetch(:name).downcase
    def tier_background_class = TIER_CLASSES.fetch(tier_key).fetch(:background)
    def perk_text_class(perk) = TIER_CLASSES.fetch(perk.fetch(:tier)).fetch(:text)
  end
end
