module Ui
  class AlertComponent < ViewComponent::Base
    VARIANTS = {
      notice: "alert-notice",
      alert: "alert-danger",
      neutral: "alert-neutral"
    }.freeze

    def initialize(variant: :neutral, dismissible: false, **attributes)
      @variant = VARIANTS.fetch(variant)
      @dismissible = dismissible
      @attributes = attributes
    rescue KeyError
      raise ArgumentError, "Unsupported alert option"
    end

    private

    attr_reader :dismissible

    def attributes
      data = @attributes.fetch(:data, {})
      data = data.merge(controller: class_names(data[:controller], "alert")) if dismissible

      { role: "status" }.merge(@attributes).merge(
        class: class_names("alert", @variant, @attributes[:class]),
        data: data
      )
    end
  end
end
