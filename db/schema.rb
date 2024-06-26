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

ActiveRecord::Schema[7.1].define(version: 2024_01_18_025634) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "card_assignees", force: :cascade do |t|
    t.bigint "card_id"
    t.bigint "assignee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assignee_id"], name: "index_card_assignees_on_assignee_id"
    t.index ["card_id", "assignee_id"], name: "index_card_assignees_on_card_id_and_assignee_id", unique: true
    t.index ["card_id"], name: "index_card_assignees_on_card_id"
  end

  create_table "card_histories", force: :cascade do |t|
    t.bigint "card_id", null: false
    t.bigint "user_id", null: false
    t.integer "action"
    t.string "attr"
    t.text "from"
    t.text "to"
    t.boolean "ai", default: false
    t.text "output"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "action_status", default: 0
    t.index ["card_id"], name: "index_card_histories_on_card_id"
    t.index ["user_id"], name: "index_card_histories_on_user_id"
  end

  create_table "cards", force: :cascade do |t|
    t.bigint "column_id", null: false
    t.string "name"
    t.string "code"
    t.text "description"
    t.integer "priority"
    t.integer "position"
    t.bigint "requester_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "estimate", precision: 4, scale: 2, default: "0.0"
    t.index ["column_id"], name: "index_cards_on_column_id"
    t.index ["requester_id"], name: "index_cards_on_requester_id"
  end

  create_table "columns", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "name"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_columns_on_project_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.bigint "commenter_id", null: false
    t.string "resource_type", null: false
    t.bigint "resource_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commenter_id"], name: "index_comments_on_commenter_id"
    t.index ["resource_type", "resource_id"], name: "index_comments_on_resource"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.bigint "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_companies_on_owner_id"
  end

  create_table "company_users", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id", "user_id"], name: "index_company_users_on_company_id_and_user_id", unique: true
    t.index ["company_id"], name: "index_company_users_on_company_id"
    t.index ["user_id"], name: "index_company_users_on_user_id"
  end

  create_table "mentions", force: :cascade do |t|
    t.bigint "commenter_id", null: false
    t.bigint "mentioned_id", null: false
    t.string "resource_type", null: false
    t.bigint "resource_id", null: false
    t.datetime "email_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commenter_id"], name: "index_mentions_on_commenter_id"
    t.index ["mentioned_id", "resource_id", "resource_type"], name: "index_mentions_on_mentioned_and_resource", unique: true
    t.index ["mentioned_id"], name: "index_mentions_on_mentioned_id"
    t.index ["resource_type", "resource_id"], name: "index_mentions_on_resource"
  end

  create_table "openai_threads", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "thread_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_openai_threads_on_project_id"
  end

  create_table "project_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_users_on_project_id"
    t.index ["user_id", "project_id"], name: "index_project_users_on_user_id_and_project_id", unique: true
    t.index ["user_id"], name: "index_project_users_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint "card_id", null: false
    t.string "name"
    t.boolean "checked", default: false
    t.integer "position"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_tasks_on_card_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "google_photo_url"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "card_assignees", "users", column: "assignee_id"
  add_foreign_key "card_histories", "cards"
  add_foreign_key "card_histories", "users"
  add_foreign_key "cards", "columns"
  add_foreign_key "cards", "users", column: "requester_id"
  add_foreign_key "columns", "projects"
  add_foreign_key "comments", "users", column: "commenter_id"
  add_foreign_key "companies", "users", column: "owner_id"
  add_foreign_key "company_users", "companies"
  add_foreign_key "company_users", "users"
  add_foreign_key "mentions", "users", column: "commenter_id"
  add_foreign_key "mentions", "users", column: "mentioned_id"
  add_foreign_key "openai_threads", "projects"
  add_foreign_key "project_users", "projects"
  add_foreign_key "project_users", "users"
  add_foreign_key "tasks", "cards"
end
