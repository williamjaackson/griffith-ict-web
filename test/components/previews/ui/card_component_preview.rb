module Ui
  class CardComponentPreview < ViewComponent::Preview
    # Cards group related content. Turn on interactive only when the whole card has an action.
    # @param content text
    # @param tone select { choices: [default, cream, red, dark] }
    # @param padding select { choices: [none, small, medium, large] }
    # @param shadow select { choices: [none, black, red] }
    # @param interactive toggle
    def playground(content: "A concise block of related content.", tone: "default", padding: "medium", shadow: "none", interactive: false)
      render Ui::CardComponent.new(
        tone: tone.to_sym,
        padding: padding.to_sym,
        shadow: shadow.to_sym,
        interactive: interactive
      ).with_content(content)
    end

    def tones
      render_with_template
    end

    def shadows
      render_with_template
    end
  end
end
