module Ui
  class DialogComponent < ViewComponent::Base
    SIZES = {
      small: "max-w-sm",
      medium: "max-w-md",
      large: "max-w-lg"
    }.freeze

    def initialize(id:, title: nil, size: :medium, open: false, **attributes)
      raise ArgumentError, "Dialog id is required" if id.blank?

      @id = id
      @title = title
      @size = SIZES.fetch(size)
      @open = open
      @attributes = attributes
    rescue KeyError
      raise ArgumentError, "Unsupported dialog size"
    end

    private

    attr_reader :id, :title

    def attributes
      data = @attributes.fetch(:data, {})
      aria = @attributes.fetch(:aria, {})
      data = data.merge(
        action: class_names(data[:action], "click->dialog#closeBackdrop close->dialog#restoreFocus"),
        dialog_open_value: @open
      )
      aria = aria.merge(labelledby: title_id) if title && !aria.key?(:label) && !aria.key?(:labelledby)

      @attributes.merge(
        id: id,
        data: data,
        aria: aria,
        class: class_names("dialog", @size, @attributes[:class])
      )
    end

    def title_id = "#{id}-title"
  end
end
