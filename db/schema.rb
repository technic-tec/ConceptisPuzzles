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

ActiveRecord::Schema.define(version: 20151117064537) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "properties", force: :cascade do |t|
    t.string   "attr_type"
    t.string   "name"
    t.string   "value"
    t.string   "unit"
    t.integer  "puzzle_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "properties", ["puzzle_id"], name: "index_properties_on_puzzle_id", using: :btree

  create_table "puzzles", force: :cascade do |t|
    t.string   "guid"
    t.integer  "codeFamily"
    t.integer  "codeVariant"
    t.string   "codeModel"
    t.string   "serialNumber"
    t.integer  "versionMajor"
    t.integer  "versionMinor"
    t.string   "builderVersion"
    t.datetime "creationDate"
    t.datetime "releaseDate"
    t.text     "data"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "email"
    t.string   "refresh_token"
    t.string   "access_token"
    t.datetime "expires"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", using: :btree

end
