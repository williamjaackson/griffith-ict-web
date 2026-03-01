module Ui
  class ModalComponent < ViewComponent::Base
    def initialize(title: nil, controller: nil, **data)
      @title = title
      @controller = controller
      @data = data
    end

    private

    attr_reader :title, :controller

    def wrapper_data
      attrs = @data.dup
      attrs[:controller] = controller if controller
      attrs
    end

    def backdrop_data
      return {} unless controller
      { "#{controller}-target" => "backdrop", action: "click->#{controller}#closeBackdrop" }
    end

    def panel_data
      return {} unless controller
      { "#{controller}-target" => "panel" }
    end
  end
end
