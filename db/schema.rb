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

ActiveRecord::Schema.define(version: 20150527173310) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"
  enable_extension "fuzzystrmatch"

  create_table "amenities", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "img",        null: false
    t.text     "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "capacities", force: :cascade do |t|
    t.integer  "institution",                null: false
    t.integer  "reserved",       default: 0
    t.integer  "standby",        default: 0
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "institution_id"
  end

  create_table "contact_types", force: :cascade do |t|
    t.string   "type",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "contact_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "phone"
    t.string   "email"
    t.integer  "institution_id"
    t.string   "website"
  end

  create_table "institution_details", force: :cascade do |t|
    t.string   "hours"
    t.integer  "institution_id"
    t.decimal  "fees",           default: 0.0, null: false
    t.integer  "capacity",       default: 0,   null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "institution_has_amenities", force: :cascade do |t|
    t.integer  "amenity_id"
    t.integer  "institution_id"
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
    t.string   "streetLine1",    null: false
    t.string   "streetLine2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "institution_id"
    t.decimal  "lat"
    t.decimal  "long"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "pg_search_documents", ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id", using: :btree

  create_table "restrictions", force: :cascade do |t|
    t.string   "name",           null: false
    t.string   "desc"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "institution_id"
  end

  create_table "subscribers", force: :cascade do |t|
    t.string   "phone",          null: false
    t.integer  "institution_id", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.integer  "institution_id"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
