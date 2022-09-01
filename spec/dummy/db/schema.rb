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

ActiveRecord::Schema.define(version: 2022_09_01_075514) do

  create_table "admin_users", force: :cascade do |t|
    t.integer "user_group_id", null: false
    t.string "username"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resource_quotable_quota", force: :cascade do |t|
    t.integer "group_id", null: false
    t.string "resource_class", null: false
    t.integer "action", default: 0, null: false
    t.integer "period", default: 0, null: false
    t.integer "limit", default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["group_id", "resource_class", "action", "period"], name: "resource_quotable_quota_unique_index", unique: true
    t.index ["group_id"], name: "index_resource_quotable_quota_on_group_id"
  end

  create_table "resource_quotable_quotum_trackers", force: :cascade do |t|
    t.integer "quotum_id", null: false
    t.integer "user_id", null: false
    t.boolean "flag", default: false, null: false
    t.integer "counter", default: 0, null: false
    t.index ["quotum_id"], name: "index_resource_quotable_quotum_trackers_on_quotum_id"
    t.index ["user_id", "quotum_id"], name: "resource_quotable_quotum_trackers_unique_index", unique: true
    t.index ["user_id"], name: "index_resource_quotable_quotum_trackers_on_user_id"
  end

  create_table "user_groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "admin_users", "user_groups"
end
