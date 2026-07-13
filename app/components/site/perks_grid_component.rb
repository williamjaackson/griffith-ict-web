module Site
  class PerksGridComponent < ViewComponent::Base
    COLUMNS = 6
    MODAL_ID = "perk-modal"

    def initialize(perks:)
      @perks = perks
    end

    def render? = perks.any?

    private

    attr_reader :perks

    def placeholder_count
      [ (perks.length.fdiv(COLUMNS)).ceil * COLUMNS, COLUMNS ].max - perks.length
    end

    def button_data(perk)
      Ui::ModalComponent.trigger_data(MODAL_ID, before: "perk-modal#populate").merge(
        perk_name: perk.fetch(:name),
        perk_icon: perk.fetch(:icon),
        perk_description: perk.fetch(:description),
        perk_website: perk.fetch(:website)
      )
    end
  end
end
