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

ActiveRecord::Schema.define(version: 2022_01_07_013746) do

  create_table "contents", force: :cascade do |t|
    t.string "title", null: false
    t.string "media", null: false
    t.text "url", null: false
    t.integer "stream", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "registered", default: false, null: false
    t.integer "master_id"
    t.boolean "new_flag", default: false, null: false
    t.integer "episode", default: 0
    t.boolean "line_flag", default: false, null: false
  end

  create_table "line_flags", force: :cascade do |t|
    t.integer "user_id"
    t.integer "content_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_id"], name: "index_line_flags_on_content_id"
    t.index ["user_id"], name: "index_line_flags_on_user_id"
  end

  create_table "line_notifications", force: :cascade do |t|
    t.integer "master_id"
    t.integer "month", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["master_id"], name: "index_line_notifications_on_master_id"
  end

  create_table "masters", force: :cascade do |t|
    t.string "title", null: false
    t.string "media", null: false
    t.text "url", null: false
    t.integer "stream", default: 0, null: false
    t.integer "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "episode", default: 0
    t.string "season"
    t.string "update_day"
    t.integer "line_notifications_count", default: 0, null: false
  end

  create_table "schedules", force: :cascade do |t|
    t.string "day", null: false
    t.integer "content_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "position"
    t.index ["content_id"], name: "index_schedules_on_content_id"
    t.index ["user_id"], name: "index_schedules_on_user_id"
  end

  create_table "user_contents", force: :cascade do |t|
    t.integer "user_id"
    t.integer "content_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_id"], name: "index_user_contents_on_content_id"
    t.index ["user_id"], name: "index_user_contents_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.string "line_nonce"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
