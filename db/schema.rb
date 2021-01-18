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

ActiveRecord::Schema.define(version: 2021_01_18_181950) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "discord_notifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "notificable_type", null: false
    t.uuid "notificable_id", null: false
    t.string "title"
    t.string "description"
    t.string "url"
    t.string "thumbnail"
    t.jsonb "fields", default: []
    t.datetime "sent_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "image"
    t.index ["created_at"], name: "index_discord_notifications_on_created_at", order: :desc
    t.index ["notificable_type", "notificable_id"], name: "index_discord_notifications_on_notificable"
    t.index ["sent_at"], name: "index_discord_notifications_on_sent_at", where: "(sent_at IS NULL)"
  end

  create_table "items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "external_id", limit: 128, null: false
    t.string "title", limit: 256, null: false
    t.string "slug", limit: 512, null: false
    t.string "description", limit: 4096
    t.string "website_url", null: false
    t.string "nsuid", limit: 128
    t.string "main_picture_url", limit: 512, null: false
    t.string "banner_picture_url", limit: 512
    t.string "screenshot_url", limit: 512
    t.string "genres", default: [], array: true
    t.string "developers", default: [], array: true
    t.string "publishers", default: [], array: true
    t.string "franchises", default: [], array: true
    t.jsonb "extra", default: {}
    t.date "release_date", null: false
    t.string "release_date_display", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["external_id"], name: "index_items_on_external_id", unique: true
    t.index ["nsuid"], name: "index_items_on_nsuid", where: "(nsuid IS NOT NULL)"
    t.index ["slug"], name: "index_items_on_slug", unique: true
  end

  create_table "price_change_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "price_id", null: false
    t.date "reference_date", null: false
    t.integer "value_cents", default: 0, null: false
    t.string "value_currency", default: "USD", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["price_id", "reference_date"], name: "index_price_change_records_on_price_id_and_reference_date", unique: true
    t.index ["price_id"], name: "index_price_change_records_on_price_id"
  end

  create_table "prices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "item_id", null: false
    t.string "nsuid", null: false
    t.integer "regular_price_cents", default: 0, null: false
    t.string "regular_price_currency", default: "USD", null: false
    t.integer "discount_price_cents"
    t.string "discount_price_currency", default: "USD", null: false
    t.datetime "discount_start_date"
    t.datetime "discount_end_date"
    t.string "state", null: false
    t.integer "discount_percentage"
    t.jsonb "data", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_id"], name: "index_prices_on_item_id", unique: true
    t.index ["nsuid"], name: "index_prices_on_nsuid", unique: true
  end

  create_table "raw_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "item_id"
    t.string "external_id", limit: 128, null: false
    t.jsonb "data", default: {}
    t.string "checksum", limit: 512, null: false
    t.boolean "imported", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["external_id"], name: "index_raw_items_on_external_id", unique: true
    t.index ["imported"], name: "index_raw_items_on_imported", where: "(imported = false)"
    t.index ["item_id"], name: "index_raw_items_on_item_id"
  end

  create_table "tasks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.string "status"
    t.string "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "price_change_records", "prices"
  add_foreign_key "prices", "items"
  add_foreign_key "raw_items", "items"
end
