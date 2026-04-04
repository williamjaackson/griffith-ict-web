module Ui
  class SelectComponent < ViewComponent::Base
    def initialize(name:, options:, selected: nil, label: nil)
      @name = name
      @options = options
      @selected = selected
      @label = label
    end

    private

    def selected_option
      @options.find { |o| o[:value].to_s == @selected.to_s } || @options.first
    end
  end
end
