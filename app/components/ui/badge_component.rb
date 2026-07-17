module Ui
  class BadgeComponent < ViewComponent::Base
    VARIANTS = {
      brand: nil,
      dark: "badge-dark",
      success: "badge-success",
      neutral: "badge-neutral"
    }.freeze

    SIZES = {
      small: "badge-sm",
      medium: nil
    }.freeze

    def initialize(variant: :brand, size: :medium, **attributes)
      @variant = VARIANTS.fetch(variant)
      @size = SIZES.fetch(size)
      @attributes = attributes
    rescue KeyError
      raise ArgumentError, "Unsupported badge option"
    end

    def call
      content_tag :span, content, **@attributes.merge(class: class_names("badge", @variant, @size, @attributes[:class]))
    end
  end
end
