module Ui
  class AlertComponentPreview < ViewComponent::Preview
    # Alerts communicate a page-level result or important neutral information.
    # @param message text
    # @param variant select { choices: [notice, alert, neutral] }
    # @param dismissible toggle
    def playground(message: "Your changes were saved.", variant: "notice", dismissible: true)
      render Ui::AlertComponent.new(variant: variant.to_sym, dismissible: dismissible).with_content(message)
    end

    def variants
      render_with_template
    end

    def dismissible
      render Ui::AlertComponent.new(variant: :notice, dismissible: true).with_content("Your changes were saved.")
    end
  end
end
