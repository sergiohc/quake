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

ActiveRecord::Schema[8.0].define(version: 2025_02_10_210720) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "death_causes", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "games", force: :cascade do |t|
    t.integer "total_kills", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "start_time_seconds"
    t.integer "end_time_seconds"
  end

  create_table "kills", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.bigint "killer_id"
    t.bigint "victim_id", null: false
    t.bigint "death_cause_id", null: false
    t.boolean "world_kill", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "time_seconds"
    t.index ["death_cause_id"], name: "index_kills_on_death_cause_id"
    t.index ["game_id"], name: "index_kills_on_game_id"
    t.index ["killer_id"], name: "index_kills_on_killer_id"
    t.index ["victim_id"], name: "index_kills_on_victim_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "username", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.string "phone_number"
    t.string "phone_number_confirmation_token"
    t.datetime "phone_number_confirmed_at"
    t.datetime "phone_number_confirmation_created_at"
    t.string "unconfirmed_phone_number"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "first_name"
    t.string "last_name"
    t.virtual "full_name", type: :string, as: "(((first_name)::text || ' '::text) || (last_name)::text)", stored: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone_number"], name: "index_users_on_phone_number", unique: true
    t.index ["phone_number_confirmation_token"], name: "index_users_on_phone_number_confirmation_token", unique: true, where: "(phone_number_confirmation_token IS NOT NULL)"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end
end
