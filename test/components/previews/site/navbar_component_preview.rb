module Site
  class NavbarComponentPreview < ViewComponent::Preview
    def default
      render Site::NavbarComponent.new
    end
  end
end
