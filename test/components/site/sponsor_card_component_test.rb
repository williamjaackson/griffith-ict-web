require "test_helper"

module Site
  class SponsorCardComponentTest < ViewComponent::TestCase
    test "renders a linked sponsor with its tier styling" do
      render_inline(SponsorCardComponent.new(sponsor: {
        name: "Example",
        tier: "Ruby",
        logo: "/sponsors/example.png",
        website: "https://example.com"
      }))
      document = Nokogiri::HTML5.fragment(rendered_content)

      assert_equal "https://example.com", document.at_css("a")["href"]
      assert_equal "Example", document.at_css("img")["alt"]
      assert_equal "RUBY", document.at_css(".badge").text
      assert_includes document.at_css(".badge")["style"], "--color-tier-ruby"
    end

    test "renders a placeholder without sponsor data" do
      render_inline(SponsorCardComponent.new)

      assert_includes rendered_content, "Your logo here"
    end

    test "rejects unsupported sponsorship tiers" do
      assert_raises(KeyError) do
        render_inline(SponsorCardComponent.new(sponsor: {
          name: "Example",
          tier: "Unknown",
          logo: "/sponsors/example.png",
          website: "https://example.com"
        }))
      end
    end
  end
end
