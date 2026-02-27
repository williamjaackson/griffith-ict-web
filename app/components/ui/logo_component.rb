module Ui
  class LogoComponent < ViewComponent::Base
    IMAGES = {
      icon: "/logo/GriffithICTClubIcon.svg",
      full: "/logo/GriffithICTClubLogo.svg"
    }.freeze

    SIZE_CLASSES = {
      icon: "h-8 w-auto",
      full: "h-6 w-auto"
    }.freeze

    def initialize(type: :icon, **options)
      @type = type.to_sym
      @extra_class = options.delete(:class)
      @options = options
    end

    private

    def src
      IMAGES[@type]
    end

    def alt
      "Griffith ICT Club"
    end

    def classes
      [SIZE_CLASSES[@type], @extra_class].compact.join(" ")
    end
  end
end
