module Site
  class FlashComponentPreview < ViewComponent::Preview
    def messages
      render FlashComponent.new(flash: { notice: "Changes saved.", alert: "Something went wrong." })
    end
  end
end
