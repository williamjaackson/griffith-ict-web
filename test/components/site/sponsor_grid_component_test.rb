require "test_helper"

module Site
  class SponsorGridComponentTest < ViewComponent::TestCase
    test "fills the four-column grid while reserving its final slot for the call to action" do
      render_inline(SponsorGridComponent.new(sponsors: []))
      document = Nokogiri::HTML5.fragment(rendered_content)

      assert_equal 3, document.text.scan("Your logo here").length
      assert_equal "/sponsorship", document.at_css("a")["href"]
      assert_includes document.text, "Sponsor Us"
    end
  end
end
