require "test_helper"

module Site
  class FlashComponentTest < ViewComponent::TestCase
    test "does not render without messages" do
      render_inline(FlashComponent.new(flash: {}))

      assert_empty rendered_content
    end

    test "renders and styles each message" do
      render_inline(FlashComponent.new(flash: {
        notice: "Saved successfully.",
        alert: "Something went wrong."
      }))

      document = Nokogiri::HTML5.fragment(rendered_content)

      assert document.at_css("[data-controller=flash]")
      assert_equal 2, document.css("[data-flash-target=toast]").size
      assert_equal "status", document.at_css("[data-flash-target=toast]")["role"]
      assert_equal "alert", document.css("[data-flash-target=toast]").last["role"]
      assert document.at_css("button[type=button][aria-label=Dismiss]")
      assert_includes document.text, "Saved successfully."
      assert_includes document.text, "Something went wrong."
    end
  end
end
