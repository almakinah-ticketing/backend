# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180103150714) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "f_name"
    t.string "l_name"
    t.string "email"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  create_table "attendees", force: :cascade do |t|
    t.string "f_name"
    t.string "l_name"
    t.string "email"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "img", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "title", null: false
    t.text "overview", null: false
    t.text "agenda", null: false
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "img", null: false
    t.datetime "start_datetime", null: false
    t.datetime "end_datetime", null: false
    t.date "event_date", null: false
    t.index ["category_id"], name: "index_events_on_category_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.integer "attendee_id", null: false
    t.integer "type_id", null: false
    t.integer "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attendee_id"], name: "index_tickets_on_attendee_id"
    t.index ["event_id"], name: "index_tickets_on_event_id"
    t.index ["type_id"], name: "index_tickets_on_type_id"
  end

  create_table "types", force: :cascade do |t|
    t.string "name", null: false
    t.float "price", null: false
    t.integer "capacity", null: false
    t.integer "group_ticket_no", default: 1, null: false
    t.integer "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_types_on_event_id"
  end

  add_foreign_key "events", "categories"
end
