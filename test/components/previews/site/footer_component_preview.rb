module Site
  class FooterComponentPreview < ViewComponent::Preview
    def default
      render FooterComponent.new
    end
  end
end
