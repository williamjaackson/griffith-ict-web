module Ui
  class BadgeComponent < ViewComponent::Base
    BASE_CLASSES = "inline-block text-white font-bold border-3 border-brand-black"

    VARIANT_CLASSES = {
      primary: "bg-brand-red",
      dark: "bg-brand-black"
    }.freeze

    SIZE_CLASSES = {
      base: "text-sm px-4 py-1.5 uppercase",
      sm: "text-xs px-3 py-1"
    }.freeze

    def initialize(text:, variant: :primary, size: :base, color: nil, **options)
      @text = text
      @variant = variant.to_sym
      @size = size.to_sym
      @color = color
      @extra_class = options.delete(:class)
      @options = options
    end

    private

    def style
      base = "font-family: 'Unbounded', sans-serif; font-weight: 600;"
      @color ? "#{base} background-color: #{@color};" : base
    end

    def classes
      [
        BASE_CLASSES,
        @color ? nil : VARIANT_CLASSES[@variant],
        SIZE_CLASSES[@size],
        @extra_class
      ].compact.join(" ")
    end
  end
end
