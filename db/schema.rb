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

ActiveRecord::Schema.define(version: 20151028024138) do

  create_table "properties", force: :cascade do |t|
    t.string   "type"
    t.string   "name"
    t.string   "value"
    t.string   "unit"
    t.integer  "puzzle_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "puzzles", force: :cascade do |t|
    t.string   "guid"
    t.integer  "codeFamily"
    t.integer  "codeVariant"
    t.string   "codeModel"
    t.string   "serialNumber"
    t.integer  "versionMajor"
    t.integer  "versionMinor"
    t.string   "builderVersion"
    t.date     "creationDate"
    t.date     "releaseDate"
    t.text     "data"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

end
