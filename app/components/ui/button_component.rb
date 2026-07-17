module Ui
  class ButtonComponent < ViewComponent::Base
    VARIANTS = {
      primary: "btn-primary",
      secondary: "btn-secondary",
      danger: "btn-danger",
      quiet: "btn-quiet"
    }.freeze

    SIZES = {
      small: "btn-sm",
      medium: nil
    }.freeze

    TYPES = %i[button submit reset].freeze

    def initialize(variant: :primary, size: :medium, href: nil, type: :button, disabled: false, **attributes)
      @variant = VARIANTS.fetch(variant)
      @size = SIZES.fetch(size)
      @href = href
      @type = type.to_sym
      raise ArgumentError, "Unsupported button type" unless TYPES.include?(@type)
      @disabled = disabled
      @attributes = attributes
    rescue KeyError, NoMethodError
      raise ArgumentError, "Unsupported button option"
    end

    def call
      href ? link_to(content, disabled ? nil : href, **link_attributes) : button_tag(content, **button_attributes)
    end

    private

    attr_reader :href, :type, :disabled

    def attributes
      @attributes.merge(class: class_names("btn", @variant, @size, @attributes[:class]))
    end

    def link_attributes
      return attributes unless disabled

      attributes.merge(aria: attributes.fetch(:aria, {}).merge(disabled: true), tabindex: -1)
    end

    def button_attributes
      attributes.merge(type: type, disabled: disabled)
    end
  end
end
