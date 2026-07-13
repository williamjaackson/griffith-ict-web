module Site
  class SponsorshipTierComponent < ViewComponent::Base
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
  end
end
