module Ui
  class HeadingComponent < ViewComponent::Base
    LEVELS = {
      1 => {
        tag: :h1,
        classes: "text-5xl sm:text-6xl md:text-7xl lg:text-8xl leading-[0.95] mb-8 text-brand-black",
        weight: 800
      },
      2 => {
        tag: :h2,
        classes: "text-3xl md:text-5xl mb-4 text-brand-black",
        weight: 800
      },
      3 => {
        tag: :h3,
        classes: "text-xl mb-2 text-brand-black",
        weight: 700
      },
      4 => {
        tag: :h4,
        classes: "text-sm mb-4 text-brand-red",
        weight: 600
      }
    }.freeze

    def initialize(text:, level: 1, highlight: nil, **options)
      @text = text
      @level = level
      @highlight = highlight
      @extra_class = options.delete(:class)
      @options = options
    end

    private

    def config
      LEVELS[@level]
    end

    def tag
      config[:tag]
    end

    def classes
      [config[:classes], @extra_class].compact.join(" ")
    end

    def style
      "font-family: 'Unbounded', sans-serif; font-weight: #{config[:weight]};"
    end

    def formatted_text
      return @text unless @highlight

      escaped = ERB::Util.html_escape(@text)
      highlighted = ERB::Util.html_escape(@highlight)
      replacement = '<span class="relative inline-block">' \
                    "#{highlighted}" \
                    '<span class="absolute -bottom-1 left-0 right-0 h-4 bg-brand-red/20 -z-10"></span>' \
                    "</span>"
      escaped.sub(highlighted, replacement).html_safe
    end
  end
end
