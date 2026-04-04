module Site
  class FlashComponent < ViewComponent::Base
    def initialize(flash:)
      @flash = flash
    end

    def render?
      @flash.any?
    end

    private

    def messages
      @flash.map do |type, message|
        { type: type.to_sym, message: message }
      end
    end

    def styles_for(type)
      case type
      when :alert
        "bg-brand-red text-white"
      when :notice
        "bg-green-600 text-white"
      else
        "bg-brand-cream text-brand-black"
      end
    end
  end
end
