module Site
  module Navbar
    class MobileComponent < ViewComponent::Base
      def initialize(links:, cta:)
        @links = links
        @cta = cta
      end

      private

      attr_reader :links, :cta

      def dropdown_id(link)
        "mobile-#{link.fetch(:label).parameterize}-navigation"
      end
    end
  end
end
