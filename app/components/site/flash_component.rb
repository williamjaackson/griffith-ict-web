module Site
  class FlashComponent < ViewComponent::Base
    def initialize(flash:)
      @flash = flash
    end

    def render?
      @flash.any?
    end

    private

    def messages = @flash.map { |type, message| [ type.to_sym, message ] }

    def variant(type) = %i[alert notice].include?(type) ? type : :neutral
  end
end
