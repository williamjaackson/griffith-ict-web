module Site
  class FooterComponentPreview < ViewComponent::Preview
    def default
      render Site::FooterComponent.new
    end
  end
end
