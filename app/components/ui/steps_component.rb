module Ui
  class StepsComponent < ViewComponent::Base
    def initialize(labels:, current: 1, **attributes)
      @labels = Array(labels)
      @current = normalize_current(current)
      @attributes = attributes

      raise ArgumentError, "Steps require at least two labels" unless @labels.size >= 2 && @labels.all?(&:present?)
      raise ArgumentError, "Current step is out of range" unless @current.between?(1, @labels.size)
    end

    private

    attr_reader :labels

    def attributes
      @attributes.merge(class: class_names("steps", @attributes[:class]), aria: { label: "Progress", **@attributes[:aria] })
    end

    def state_for(step)
      return "complete" if step < @current
      return "current" if step == @current

      "upcoming"
    end

    def normalize_current(current)
      Integer(current)
    rescue ArgumentError, TypeError
      raise ArgumentError, "Current step must be a number"
    end
  end
end
