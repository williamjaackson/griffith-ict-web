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
  end
end
