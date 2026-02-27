module Ui
  class LogoComponent < ViewComponent::Base
    IMAGES = {
      icon: "/logo/GriffithICTClubIcon.svg",
      full: "/logo/GriffithICTClubLogo.svg"
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
      @extra_class
    end
  end
end
