module Ui
  class ButtonComponentPreview < ViewComponent::Preview
    def primary
      render ButtonComponent.new.with_content("Primary action")
    end

    def variants
      render_with_template
    end

    def sizes
      render_with_template
    end

    def disabled
      render ButtonComponent.new(disabled: true).with_content("Unavailable")
    end
  end
end
