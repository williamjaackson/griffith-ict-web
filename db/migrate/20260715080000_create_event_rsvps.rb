class CreateEventRsvps < ActiveRecord::Migration[8.1]
  def change
    create_table :event_rsvps do |t|
      t.string :event_slug, null: false
      t.string :full_name, null: false
      t.string :student_email, null: false
      t.string :student_number, null: false

      t.timestamps
    end

    add_index :event_rsvps, [ :event_slug, :student_email ], unique: true
    add_index :event_rsvps, [ :event_slug, :student_number ], unique: true
  end
end
