class AddMembershipConfirmationToEventRsvps < ActiveRecord::Migration[8.1]
  def change
    add_column :event_rsvps, :membership_confirmed, :boolean, null: false, default: false
  end
end
