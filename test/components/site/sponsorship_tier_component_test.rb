require "test_helper"

module Site
  class SponsorshipTierComponentTest < ViewComponent::TestCase
    test "renders inherited perks with the tier that introduced each one" do
      inherited = tier(name: "Opal", perks: [ "Website logo" ])
      current = tier(name: "Amber", perks: [ "Job promotion" ])

      render_inline(SponsorshipTierComponent.new(tier: current, inherited_tiers: [ inherited ]))
      document = Nokogiri::HTML5.fragment(rendered_content)
      perks = document.css("li")

      assert_equal [ "Website logo", "Job promotion" ], perks.map { |item| item.text.strip }
      assert_includes perks.first.at_css("span")["class"], "text-tier-opal"
      assert_includes perks.last.at_css("span")["class"], "text-tier-amber"
    end

    private

    def tier(name:, perks:)
      {
        name: name,
        price: "$500",
        rotation: "rotate-2",
        description: "Example tier",
        perks: perks
      }
    end
  end
end
