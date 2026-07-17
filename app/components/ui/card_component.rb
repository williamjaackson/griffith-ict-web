module Ui
  class CardComponent < ViewComponent::Base
    TAGS = %i[article aside button div li section].freeze

    TONES = {
      default: nil,
      cream: "card-cream",
      red: "card-red",
      dark: "card-dark"
    }.freeze

    PADDINGS = {
      none: "p-0",
      small: "card-sm",
      medium: nil,
      large: "card-lg"
    }.freeze

    SHADOWS = {
      none: nil,
      black: "card-shadow-black",
      red: "card-shadow-red"
    }.freeze

    def initialize(tag: :div, tone: :default, padding: :medium, shadow: :none, interactive: false, **attributes)
      @tag = tag.to_sym
      raise ArgumentError, "Unsupported card tag" unless TAGS.include?(@tag)

      @tone = TONES.fetch(tone)
      @padding = PADDINGS.fetch(padding)
      @shadow = SHADOWS.fetch(shadow)
      @interactive = interactive
      @attributes = attributes
    rescue KeyError, NoMethodError
      raise ArgumentError, "Unsupported card option"
    end

    def call
      content_tag @tag, content, **@attributes.merge(class: css_classes)
    end

    private

    def css_classes
      class_names("card", @tone, @padding, @shadow, { "card-link": @interactive }, @attributes[:class])
    end
  end
end
