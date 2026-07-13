require "test_helper"

module Ui
  class ModalComponentTest < ViewComponent::TestCase
    test "renders content with optional title and controller data" do
      render_inline(ModalComponent.new(
        title: "Example modal",
        controller: "example",
        example_url_value: "https://example.com"
      )) { "Modal content" }

      document = Nokogiri::HTML5.fragment(rendered_content)

      assert document.at_css("[data-controller=example][data-example-url-value='https://example.com']")
      assert document.at_css("[data-example-target=backdrop]")
      assert document.at_css("[data-example-target=panel]")
      assert_equal "Example modal", document.at_css("h2").text
      assert_includes document.text, "Modal content"
    end
  end
end
