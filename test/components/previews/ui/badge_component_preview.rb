module Ui
  class BadgeComponentPreview < ViewComponent::Preview
    # Badges label compact status or category information; they are not interactive.
    # @param label text
    # @param variant select { choices: [brand, dark, success, neutral] }
    # @param size select { choices: [small, medium] }
    def playground(label: "Upcoming", variant: "brand", size: "medium")
      render Ui::BadgeComponent.new(variant: variant.to_sym, size: size.to_sym).with_content(label)
    end

    def variants
      render_with_template
    end

    def sizes
      render_with_template
    end
  end
end
