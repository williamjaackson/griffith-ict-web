module Site
  module Navbar
    class DesktopComponent < ViewComponent::Base
      def initialize(links:, cta:)
        @links = links
        @cta = cta
      end

      private

      attr_reader :links, :cta

      def underline_span
        tag.span(class: "absolute -bottom-1 left-1/2 w-0 h-0.5 bg-brand-red transition-all duration-300 group-hover:w-full group-hover:left-0")
      end
    end
  end
end
