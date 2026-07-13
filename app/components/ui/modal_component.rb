module Ui
  class ModalComponent < ViewComponent::Base
    SIZES = {
      medium: "max-w-md",
      large: "max-w-lg"
    }.freeze

    def self.trigger_data(id, before: nil)
      raise ArgumentError, "id cannot be blank" if id.blank?

      {
        action: [ before, "modal#open" ].compact.join(" "),
        modal_id_param: id
      }
    end

    def initialize(id:, title: nil, label: nil, labelled_by: nil, size: :medium, data: {})
      raise ArgumentError, "id cannot be blank" if id.blank?
      raise ArgumentError, "provide a title, label, or labelled_by" if [ title, label, labelled_by ].all?(&:blank?)

      @id = id
      @title = title
      @label = label
      @labelled_by = labelled_by
      @size = SIZES.fetch(size)
      @data = data
    end

    private

    attr_reader :id, :title

    def dialog_data
      @data.merge(
        modal_target: "dialog",
        action: [ @data[:action], "click->modal#closeBackdrop" ].compact.join(" ")
      )
    end

    def dialog_aria
      return { modal: true, labelledby: @labelled_by || title_id } if @labelled_by || title

      { modal: true, label: @label }
    end

    def panel_classes
      [
        "relative bg-brand-bg border-3 border-brand-black",
        "shadow-[6px_6px_0px_var(--color-brand-black)] w-full #{@size}",
        "max-h-[calc(100vh-3rem)] overflow-y-auto p-8",
        "scale-95 opacity-0 transition-all duration-300 focus:outline-none"
      ].join(" ")
    end

    def title_id = "#{id}-title"
  end
end
