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

ActiveRecord::Schema.define(version: 20160221211133) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "character_states", force: :cascade do |t|
    t.integer  "character_id"
    t.jsonb    "quests"
    t.jsonb    "items"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "character_states", ["character_id"], name: "index_character_states_on_character_id", using: :btree

  create_table "characters", force: :cascade do |t|
    t.integer  "social_id",          limit: 8
    t.integer  "level",                        default: 1,     null: false
    t.integer  "energy",                                       null: false
    t.integer  "ep",                                           null: false
    t.integer  "health",                                       null: false
    t.integer  "hp",                                           null: false
    t.integer  "attack",                                       null: false
    t.integer  "defense",                                      null: false
    t.integer  "experience",                   default: 0,     null: false
    t.integer  "points",                       default: 0,     null: false
    t.integer  "basic_money",                                  null: false
    t.integer  "vip_money",                                    null: false
    t.string   "session_key"
    t.string   "session_secret_key"
    t.boolean  "installed",                    default: false
    t.datetime "ep_updated_at"
    t.datetime "hp_updated_at"
    t.datetime "last_visited_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "characters", ["social_id"], name: "index_characters_on_social_id", using: :btree

  add_foreign_key "character_states", "characters"
end
