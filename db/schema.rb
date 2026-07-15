# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_07_15_090000) do
  create_table "event_rsvps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "event_slug", null: false
    t.string "full_name", null: false
    t.boolean "membership_confirmed", default: false, null: false
    t.string "student_email", null: false
    t.string "student_number", null: false
    t.datetime "updated_at", null: false
    t.index ["event_slug", "student_email"], name: "index_event_rsvps_on_event_slug_and_student_email", unique: true
    t.index ["event_slug", "student_number"], name: "index_event_rsvps_on_event_slug_and_student_number", unique: true
  end

  create_table "invites", force: :cascade do |t|
    t.datetime "accepted_at"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.datetime "expires_at", null: false
    t.integer "invited_by_id", null: false
    t.integer "role", default: 1, null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.index ["invited_by_id"], name: "index_invites_on_invited_by_id"
    t.index ["token"], name: "index_invites_on_token", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.integer "role", default: 1, null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "invites", "users", column: "invited_by_id"
  add_foreign_key "sessions", "users"
end
