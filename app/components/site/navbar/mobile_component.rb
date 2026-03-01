module Site
  module Navbar
    class MobileComponent < ViewComponent::Base
      def initialize(links:, cta:)
        @links = links
        @cta = cta
      end

      private

      attr_reader :links, :cta
    end
  end
end
