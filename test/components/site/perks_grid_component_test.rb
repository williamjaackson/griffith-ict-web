require "test_helper"

module Site
  class PerksGridComponentTest < ViewComponent::TestCase
    test "renders perk modal data and fills the six-column grid" do
      perks = 3.times.map do |index|
        {
          name: "Perk #{index}",
          logo: "/sponsors/perk.png",
          icon: "/sponsors/perk-icon.png",
          website: "https://example.com/#{index}",
          description: "Example perk #{index}"
        }
      end

      render_inline(PerksGridComponent.new(perks: perks))
      document = Nokogiri::HTML5.fragment(rendered_content)
      first_button = document.at_css("button")

      assert_equal 3, document.css("button").length
      assert_equal 3, document.text.scan("Your logo here").length
      assert_equal "perk-modal#populate modal#open", first_button["data-action"]
      assert_equal "perk-modal", first_button["data-modal-id-param"]
      assert_equal "Perk 0", first_button["data-perk-name"]
    end

    test "does not render without perks" do
      render_inline(PerksGridComponent.new(perks: []))

      assert_empty rendered_content
    end
  end
end
