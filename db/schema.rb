# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151107215136) do

  create_table "cards", force: :cascade do |t|
    t.string   "value"
    t.string   "suit"
    t.string   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.string   "content"
    t.integer  "room_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "messages", ["room_id"], name: "index_messages_on_room_id"
  add_index "messages", ["user_id"], name: "index_messages_on_user_id"

  create_table "room_cards", force: :cascade do |t|
    t.integer  "card_id"
    t.integer  "room_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "room_cards", ["card_id"], name: "index_room_cards_on_card_id"
  add_index "room_cards", ["room_id"], name: "index_room_cards_on_room_id"
  add_index "room_cards", ["user_id"], name: "index_room_cards_on_user_id"

  create_table "room_types", force: :cascade do |t|
    t.string   "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.string   "name"
    t.integer  "room_type_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "rooms", ["room_type_id"], name: "index_rooms_on_room_type_id"

  create_table "users", force: :cascade do |t|
    t.string   "user_name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.integer  "score",           default: 0
    t.boolean  "stay",            default: false
    t.boolean  "bust",            default: false
    t.boolean  "win",             default: false
    t.boolean  "dealer",          default: false
    t.integer  "wins",            default: 0
    t.integer  "room_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "users", ["room_id"], name: "index_users_on_room_id"

end
