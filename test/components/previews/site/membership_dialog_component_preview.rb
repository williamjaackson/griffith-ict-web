module Site
  class MembershipDialogComponentPreview < ViewComponent::Preview
    # Membership composes Dialog, Steps, and Button without constructing content in JavaScript.
    def default
      render_with_template
    end
  end
end
