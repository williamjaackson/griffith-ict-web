module Ui
  class InputComponent < ViewComponent::Base
    INPUT_CLASSES = "block w-full rounded-md border-2 border-brand-cream bg-brand-bg focus:outline-none focus:border-brand-red px-3 py-2.5"
    LABEL_CLASSES = "block text-sm font-semibold text-brand-black mb-1"

    def initialize(label:, **options)
      @label = label
      @extra_class = options.delete(:class)
      @options = options
    end

    private

    def input_classes
      [INPUT_CLASSES, @extra_class].compact.join(" ")
    end
  end
end
