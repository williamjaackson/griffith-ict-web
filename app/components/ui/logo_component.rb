module Ui
  class LogoComponent < ViewComponent::Base
    IMAGES = {
      icon: "/logo/icon.png",
      full: {
        black: "/logo/full.png",
        white: "/logo/dark-mode-full.png"
      }
    }.freeze

    SIZE_CLASSES = {
      icon: "h-9 w-auto",
      full: "h-6 w-auto"
    }.freeze

    def initialize(type: :icon, variant: :black, **options)
      @type = type.to_sym
      @variant = variant.to_sym
      @extra_class = options.delete(:class)
      @options = options
    end

    private

    def src
      if @type == :icon
        IMAGES[:icon]
      else
        IMAGES[:full][@variant]
      end
    end

    def alt
      @type == :icon ? "GIC" : "Griffith ICT Club"
    end

    def classes
      [SIZE_CLASSES[@type], @extra_class].compact.join(" ")
    end
  end
end
