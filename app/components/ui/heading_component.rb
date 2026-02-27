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

    def initialize(text:, level: 1, **options)
      @text = text
      @level = level
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
  end
end
