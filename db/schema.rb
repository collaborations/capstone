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

ActiveRecord::Schema.define(version: 20150420214141) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "amenities", force: :cascade do |t|
    t.string   "name",       null: false
    t.text     "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "capacities", force: :cascade do |t|
    t.integer  "institution",                    null: false
    t.integer  "reserved",           default: 0
    t.integer  "reserved_confirmed", default: 0
    t.integer  "standby",            default: 0
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "contact_types", force: :cascade do |t|
    t.string   "type",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "contact_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "value",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "institution_has_amenities", force: :cascade do |t|
    t.string   "hours"
    t.integer  "amenity_id"
    t.integer  "institution_id"
    t.decimal  "fees"
    t.integer  "capacity"
    t.text     "desc"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "institutions", force: :cascade do |t|
    t.string   "name",         null: false
    t.text     "desc"
    t.text     "instructions"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string   "streetLine1", null: false
    t.string   "streetLine2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "restrictions", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
