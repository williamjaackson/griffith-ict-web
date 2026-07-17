module Site
  class NavbarComponentPreview < ViewComponent::Preview
    def default
      render NavbarComponent.new
    end
  end
end
