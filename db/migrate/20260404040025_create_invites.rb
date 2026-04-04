class CreateInvites < ActiveRecord::Migration[8.1]
  def change
    create_table :invites do |t|
      t.string :email, null: false
      t.integer :role, null: false, default: 1
      t.string :token, null: false
      t.datetime :expires_at, null: false
      t.datetime :accepted_at
      t.references :invited_by, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :invites, :token, unique: true
  end
end
