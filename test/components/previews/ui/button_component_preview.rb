module Ui
  class ButtonComponentPreview < ViewComponent::Preview
    # Use buttons for actions and links styled as actions. Keep labels short and specific.
    # @param label text
    # @param variant select { choices: [primary, secondary, danger, quiet] }
    # @param size select { choices: [small, medium] }
    # @param disabled toggle
    def playground(label: "Save changes", variant: "primary", size: "medium", disabled: false)
      render Ui::ButtonComponent.new(
        variant: variant.to_sym,
        size: size.to_sym,
        disabled: disabled
      ).with_content(label)
    end

    def primary
      render Ui::ButtonComponent.new.with_content("Primary action")
    end

    def variants
      render_with_template
    end

    def sizes
      render_with_template
    end

    def disabled
      render Ui::ButtonComponent.new(disabled: true).with_content("Unavailable")
    end
  end
end
