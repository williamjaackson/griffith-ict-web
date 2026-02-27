module Ui
  class ButtonComponent < ViewComponent::Base
    BASE_CLASSES = "inline-flex items-center justify-center text-center font-bold border-3 border-brand-black transition-all duration-200 hover:-translate-y-1 active:translate-y-0 active:shadow-none"

    VARIANT_CLASSES = {
      primary: "bg-brand-red text-white",
      secondary: "bg-white text-brand-black"
    }.freeze

    SIZE_CLASSES = {
      base: "px-8 py-4 text-base",
      sm: "px-5 py-2.5 text-sm"
    }.freeze

    SHADOW_CLASSES = {
      primary: "hover:shadow-[5px_5px_0px_var(--color-brand-black)]",
      secondary: "hover:shadow-[5px_5px_0px_var(--color-brand-red)]"
    }.freeze

    def initialize(label:, href:, variant:, size: :base, **options)
      @label = label
      @href = href
      @variant = variant.to_sym
      @size = size.to_sym
      @extra_class = options.delete(:class)
      @options = options
    end

    private

    def style
      "font-family: 'Unbounded', sans-serif; font-weight: 600;"
    end

    def classes
      [
        BASE_CLASSES,
        VARIANT_CLASSES[@variant],
        SIZE_CLASSES[@size],
        SHADOW_CLASSES[@variant],
        @extra_class
      ].compact.join(" ")
    end
  end
end
