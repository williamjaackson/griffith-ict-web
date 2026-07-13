module Site
  class SponsorGridComponent < ViewComponent::Base
    COLUMNS = 4

    def initialize(sponsors:)
      @sponsors = sponsors
    end

    private

    attr_reader :sponsors

    def placeholder_count
      occupied_slots = sponsors.length + 1
      total_slots = [ (occupied_slots.fdiv(COLUMNS)).ceil * COLUMNS, COLUMNS ].max
      total_slots - occupied_slots
    end
  end
end
