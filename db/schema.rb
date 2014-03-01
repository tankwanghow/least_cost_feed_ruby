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

ActiveRecord::Schema.define(version: 20140227021212) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"
  enable_extension "fuzzystrmatch"

  create_table "ingredients", force: true do |t|
    t.integer "user_id_id"
    t.string  "name"
    t.decimal "cost"
  end

  create_table "pg_search_documents", force: true do |t|
    t.date     "doc_date"
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.decimal  "doc_amount",      precision: 12, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username",                            null: false
    t.string   "email"
    t.string   "name"
    t.string   "password_digest",                     null: false
    t.string   "status",          default: "pending", null: false
    t.boolean  "is_admin",        default: false,     null: false
    t.integer  "lock_version",    default: 0,         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
