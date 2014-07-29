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

ActiveRecord::Schema.define(version: 20140729024027) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "formula_ingredients", force: true do |t|
    t.integer "formula_id",                   null: false
    t.integer "ingredient_id",                null: false
    t.float   "max"
    t.float   "min"
    t.float   "actual",        default: 0.0,  null: false
    t.float   "weight"
    t.float   "shadow",        default: 0.0,  null: false
    t.boolean "use",           default: true, null: false
  end

  add_index "formula_ingredients", ["ingredient_id", "formula_id"], name: "index_formula_ingredients_on_ingredient_id_and_formula_id", unique: true, using: :btree

  create_table "formula_nutrients", force: true do |t|
    t.integer "formula_id",                 null: false
    t.integer "nutrient_id",                null: false
    t.float   "max"
    t.float   "min"
    t.float   "actual",      default: 0.0,  null: false
    t.boolean "use",         default: true, null: false
  end

  add_index "formula_nutrients", ["nutrient_id", "formula_id"], name: "index_formula_nutrients_on_nutrient_id_and_formula_id", unique: true, using: :btree

  create_table "formulas", force: true do |t|
    t.integer  "user_id",                         null: false
    t.string   "name",                            null: false
    t.float    "batch_size",        default: 0.0, null: false
    t.float    "cost",              default: 0.0, null: false
    t.text     "note"
    t.integer  "lock_version",      default: 0,   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "target_bag_weight"
    t.integer  "bags_of_premix"
  end

  create_table "ingredient_compositions", force: true do |t|
    t.integer "ingredient_id",               null: false
    t.integer "nutrient_id",                 null: false
    t.float   "value",         default: 0.0, null: false
  end

  add_index "ingredient_compositions", ["ingredient_id", "nutrient_id"], name: "index_ingredient_compositions_on_ingredient_id_and_nutrient_id", unique: true, using: :btree

  create_table "ingredients", force: true do |t|
    t.integer  "user_id",                            null: false
    t.string   "name",                               null: false
    t.float    "package_weight", default: 0.1
    t.float    "cost",           default: 0.0,       null: false
    t.string   "status",         default: "using",   null: false
    t.string   "category",       default: "private", null: false
    t.text     "note"
    t.integer  "lock_version",   default: 0,         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ingredients", ["user_id", "name"], name: "index_ingredients_on_user_id_and_name", unique: true, using: :btree

  create_table "nutrients", force: true do |t|
    t.integer  "user_id",                          null: false
    t.string   "name",                             null: false
    t.string   "unit",                             null: false
    t.text     "note"
    t.string   "category",     default: "private", null: false
    t.integer  "lock_version", default: 0,         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "nutrients", ["user_id", "name"], name: "index_nutrients_on_user_id_and_name", unique: true, using: :btree

  create_table "premix_ingredients", force: true do |t|
    t.integer "formula_id",    null: false
    t.integer "ingredient_id", null: false
    t.float   "actual_usage"
    t.float   "premix_usage"
  end

  add_index "premix_ingredients", ["ingredient_id", "formula_id"], name: "index_premix_ingredients_on_ingredient_id_and_formula_id", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "username",                                 null: false
    t.string   "email"
    t.string   "name"
    t.string   "password_digest",                          null: false
    t.string   "status",          default: "pending",      null: false
    t.boolean  "is_admin",        default: false,          null: false
    t.string   "country",         default: "Malaysia",     null: false
    t.string   "time_zone",       default: "Kuala Lumpur", null: false
    t.string   "weight_unit",     default: "KG",           null: false
    t.integer  "lock_version",    default: 0,              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
