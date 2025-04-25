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

ActiveRecord::Schema[8.0].define(version: 2025_04_25_053809) do
  create_table "active_storage_attachments", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "asset_assignments", charset: "utf8", force: :cascade do |t|
    t.bigint "asset_id", null: false
    t.bigint "user_id", null: false
    t.datetime "assigned_at"
    t.datetime "returned_at"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asset_id"], name: "index_asset_assignments_on_asset_id"
    t.index ["user_id"], name: "index_asset_assignments_on_user_id"
  end

  create_table "asset_categories", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_asset_categories_on_name", unique: true
  end

  create_table "assets", charset: "utf8", force: :cascade do |t|
    t.string "unique_id", null: false
    t.string "name", null: false
    t.bigint "asset_category_id", null: false
    t.string "brand"
    t.string "model"
    t.text "specifications"
    t.string "serial_number"
    t.date "purchase_date"
    t.date "warranty_expiry"
    t.string "status", default: "Available", null: false
    t.string "condition"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asset_category_id"], name: "index_assets_on_asset_category_id"
    t.index ["unique_id"], name: "index_assets_on_unique_id", unique: true
  end

  create_table "audits", charset: "utf8", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.bigint "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "expenses", charset: "utf8", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2
    t.string "description"
    t.date "date"
    t.integer "category"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "notes", charset: "utf8", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id", null: false
    t.string "notable_type"
    t.bigint "notable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notable_type", "notable_id"], name: "index_notes_on_notable"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "reimbursement_requests", charset: "utf8", force: :cascade do |t|
    t.decimal "total_amount", precision: 10, scale: 2
    t.integer "status"
    t.bigint "expense_id"
    t.bigint "manager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "rejection_reason"
    t.index ["expense_id"], name: "index_reimbursement_requests_on_expense_id"
    t.index ["manager_id"], name: "index_reimbursement_requests_on_manager_id"
  end

  create_table "tickets", charset: "utf8", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "status"
    t.integer "priority"
    t.bigint "user_id"
    t.bigint "assigned_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assigned_user_id"], name: "index_tickets_on_assigned_user_id"
    t.index ["user_id"], name: "index_tickets_on_user_id"
  end

  create_table "users", charset: "utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.string "avatar"
    t.text "bio"
    t.string "phone_number"
    t.date "dob"
    t.boolean "is_active", default: false
    t.string "blood_group"
    t.text "address"
    t.string "gender"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.integer "sign_in_count", default: 0, null: false
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "asset_assignments", "assets"
  add_foreign_key "asset_assignments", "users"
  add_foreign_key "assets", "asset_categories"
  add_foreign_key "expenses", "users"
  add_foreign_key "notes", "users"
  add_foreign_key "reimbursement_requests", "expenses"
  add_foreign_key "reimbursement_requests", "users", column: "manager_id"
  add_foreign_key "tickets", "users"
  add_foreign_key "tickets", "users", column: "assigned_user_id"
end
