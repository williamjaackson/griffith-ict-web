module Ui
  class DialogComponentPreview < ViewComponent::Preview
    # Dialogs hold focused tasks that should interrupt the current page without navigating away.
    # @param title text
    # @param size select { choices: [small, medium, large] }
    def playground(title: "Confirm action", size: "medium")
      render Ui::DialogComponent.new(id: "playground-dialog", title: title, size: size.to_sym, open: true)
        .with_content("Keep dialog content focused and provide a clear next action.")
    end

    def default
      render_with_template
    end

    def sizes
      render_with_template
    end
  end
end
