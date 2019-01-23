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

ActiveRecord::Schema.define(version: 20171103034121) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "formula_ingredients", id: :serial, force: :cascade do |t|
    t.integer "formula_id", null: false
    t.integer "ingredient_id", null: false
    t.float "max"
    t.float "min"
    t.float "actual", default: 0.0, null: false
    t.float "weight"
    t.float "shadow", default: 0.0, null: false
    t.boolean "use", default: true, null: false
    t.index ["ingredient_id", "formula_id"], name: "index_formula_ingredients_on_ingredient_id_and_formula_id", unique: true
  end

  create_table "formula_ingredients_histories", force: :cascade do |t|
    t.bigint "formula_id", null: false
    t.bigint "ingredient_id", null: false
    t.decimal "actual", precision: 12, scale: 6, default: "0.0", null: false
    t.boolean "use", default: true, null: false
    t.string "logged_at", null: false
    t.index ["formula_id"], name: "index_formula_ingredients_histories_on_formula_id"
    t.index ["ingredient_id", "formula_id", "logged_at"], name: "by_ing_id_for_id_log_at", unique: true
    t.index ["ingredient_id"], name: "index_formula_ingredients_histories_on_ingredient_id"
  end

  create_table "formula_nutrients", id: :serial, force: :cascade do |t|
    t.integer "formula_id", null: false
    t.integer "nutrient_id", null: false
    t.float "max"
    t.float "min"
    t.float "actual", default: 0.0, null: false
    t.boolean "use", default: true, null: false
    t.index ["nutrient_id", "formula_id"], name: "index_formula_nutrients_on_nutrient_id_and_formula_id", unique: true
  end

  create_table "formulas", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name", limit: 255, null: false
    t.float "batch_size", default: 0.0, null: false
    t.float "cost", default: 0.0, null: false
    t.text "note"
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float "target_bag_weight", default: 1.0
    t.integer "bags_of_premix", default: 1
    t.integer "usage_bags", default: 1
    t.integer "usage_per_day", default: 0
  end

  create_table "ingredient_compositions", id: :serial, force: :cascade do |t|
    t.integer "ingredient_id", null: false
    t.integer "nutrient_id", null: false
    t.float "value", default: 0.0, null: false
    t.index ["ingredient_id", "nutrient_id"], name: "index_ingredient_compositions_on_ingredient_id_and_nutrient_id", unique: true
  end

  create_table "ingredients", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name", limit: 255, null: false
    t.float "package_weight", default: 0.1
    t.float "cost", default: 0.0, null: false
    t.string "status", limit: 255, default: "using", null: false
    t.string "category", limit: 255, default: "private", null: false
    t.text "note"
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id", "name"], name: "index_ingredients_on_user_id_and_name", unique: true
  end

  create_table "nutrients", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name", limit: 255, null: false
    t.string "unit", limit: 255, null: false
    t.text "note"
    t.string "category", limit: 255, default: "private", null: false
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id", "name"], name: "index_nutrients_on_user_id_and_name", unique: true
  end

  create_table "premix_ingredients", id: :serial, force: :cascade do |t|
    t.integer "formula_id", null: false
    t.integer "ingredient_id", null: false
    t.float "actual_usage"
    t.float "premix_usage"
    t.index ["ingredient_id", "formula_id"], name: "index_premix_ingredients_on_ingredient_id_and_formula_id", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "username", limit: 255, null: false
    t.string "email", limit: 255
    t.string "name", limit: 255
    t.string "password_digest", limit: 255, null: false
    t.string "status", limit: 255, default: "pending", null: false
    t.boolean "is_admin", default: false, null: false
    t.string "country", limit: 255, default: "Malaysia", null: false
    t.string "time_zone", limit: 255, default: "Kuala Lumpur", null: false
    t.string "weight_unit", limit: 255, default: "KG", null: false
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_login_at"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
