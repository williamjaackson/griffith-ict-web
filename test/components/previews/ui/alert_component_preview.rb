module Ui
  class AlertComponentPreview < ViewComponent::Preview
    def variants
      render_with_template
    end

    def dismissible
      render AlertComponent.new(variant: :notice, dismissible: true).with_content("Your changes were saved.")
    end
  end
end
