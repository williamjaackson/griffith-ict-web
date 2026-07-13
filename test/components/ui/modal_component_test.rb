require "test_helper"

module Ui
  class ModalComponentTest < ViewComponent::TestCase
    test "renders an accessible dialog with content and title" do
      render_inline(ModalComponent.new(
        id: "example-modal",
        title: "Example modal",
        data: { example_url_value: "https://example.com" }
      )) { "Modal content" }

      document = Nokogiri::HTML5.fragment(rendered_content)
      dialog = document.at_css("#example-modal")
      panel = dialog.at_css("[role=dialog]")

      assert_equal "dialog", dialog["data-modal-target"]
      assert_equal "true", dialog["aria-hidden"]
      assert dialog.key?("inert")
      assert_equal "https://example.com", dialog["data-example-url-value"]
      assert_equal "true", panel["aria-modal"]
      assert_equal "example-modal-title", panel["aria-labelledby"]
      assert_equal "-1", panel["tabindex"]
      assert_equal "Example modal", document.at_css("h2").text
      assert document.at_css("button[data-action='modal#close'][aria-label='Close modal']")
      assert_includes document.text, "Modal content"
    end

    test "builds consistent trigger data" do
      assert_equal(
        { action: "populate#content modal#open", modal_id_param: "example-modal" },
        ModalComponent.trigger_data("example-modal", before: "populate#content")
      )
    end

    test "requires an accessible name" do
      assert_raises(ArgumentError) { ModalComponent.new(id: "unnamed") }
      assert_raises(ArgumentError) { ModalComponent.new(id: "unnamed", label: "") }
    end

    test "requires a non-empty identifier" do
      assert_raises(ArgumentError) { ModalComponent.new(id: "", title: "Example") }
      assert_raises(ArgumentError) { ModalComponent.trigger_data(nil) }
    end
  end
end
