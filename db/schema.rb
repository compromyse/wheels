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

ActiveRecord::Schema[8.1].define(version: 2026_06_07_173911) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "bike_requests", force: :cascade do |t|
    t.integer "age"
    t.bigint "assignee_id"
    t.integer "bike_type", null: false
    t.datetime "created_at", null: false
    t.bigint "distribution_center_id", null: false
    t.date "due_date", null: false
    t.bigint "factory_id", null: false
    t.string "height"
    t.text "notes"
    t.string "phone", null: false
    t.string "recipient_name"
    t.string "requestor_name", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["assignee_id"], name: "index_bike_requests_on_assignee_id"
    t.index ["distribution_center_id"], name: "index_bike_requests_on_distribution_center_id"
    t.index ["factory_id"], name: "index_bike_requests_on_factory_id"
    t.index ["status"], name: "index_bike_requests_on_status"
    t.index ["user_id"], name: "index_bike_requests_on_user_id"
  end

  create_table "distribution_centers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "factories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_distribution_centers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "distribution_center_id", null: false
    t.string "role", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["distribution_center_id"], name: "index_user_distribution_centers_on_distribution_center_id"
    t.index ["user_id", "distribution_center_id"], name: "idx_on_user_id_distribution_center_id_d0ce0dc134", unique: true
    t.index ["user_id"], name: "index_user_distribution_centers_on_user_id"
  end

  create_table "user_factories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "factory_id", null: false
    t.string "role", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["factory_id"], name: "index_user_factories_on_factory_id"
    t.index ["user_id", "factory_id"], name: "index_user_factories_on_user_id_and_factory_id", unique: true
    t.index ["user_id"], name: "index_user_factories_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.boolean "superadmin", default: false, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "bike_requests", "distribution_centers"
  add_foreign_key "bike_requests", "factories"
  add_foreign_key "bike_requests", "users"
  add_foreign_key "bike_requests", "users", column: "assignee_id"
  add_foreign_key "user_distribution_centers", "distribution_centers"
  add_foreign_key "user_distribution_centers", "users"
  add_foreign_key "user_factories", "factories"
  add_foreign_key "user_factories", "users"
end
