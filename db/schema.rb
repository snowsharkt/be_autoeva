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

ActiveRecord::Schema[7.1].define(version: 2025_04_08_154644) do
  create_table "brands", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_brands_on_name", unique: true
  end

  create_table "comments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "sale_post_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sale_post_id"], name: "index_comments_on_sale_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "favorites", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "sale_post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sale_post_id"], name: "index_favorites_on_sale_post_id"
    t.index ["user_id", "sale_post_id"], name: "index_favorites_on_user_id_and_sale_post_id", unique: true
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "models", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "brand_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id", "name"], name: "index_models_on_brand_id_and_name", unique: true
    t.index ["brand_id"], name: "index_models_on_brand_id"
  end

  create_table "prediction_histories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "car_name"
    t.integer "year_of_manufacture"
    t.integer "mileage"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_prediction_histories_on_discarded_at"
    t.index ["user_id"], name: "index_prediction_histories_on_user_id"
  end

  create_table "reports", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "reporter_id", null: false
    t.string "reportable_type", null: false
    t.bigint "reportable_id", null: false
    t.string "reason", null: false
    t.string "status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reportable_type", "reportable_id"], name: "index_reports_on_reportable"
    t.index ["reporter_id"], name: "index_reports_on_reporter_id"
  end

  create_table "sale_post_images", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "sale_post_id", null: false
    t.string "image_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sale_post_id"], name: "index_sale_post_images_on_sale_post_id"
  end

  create_table "sale_posts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "brand_id", null: false
    t.bigint "model_id", null: false
    t.bigint "version_id", null: false
    t.string "title", null: false
    t.text "description"
    t.decimal "price", precision: 10, scale: 2
    t.integer "year"
    t.integer "odo"
    t.string "location"
    t.string "status", default: "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_sale_posts_on_brand_id"
    t.index ["model_id"], name: "index_sale_posts_on_model_id"
    t.index ["user_id"], name: "index_sale_posts_on_user_id"
    t.index ["version_id"], name: "index_sale_posts_on_version_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "role", default: "user", null: false
    t.string "phone_number"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.boolean "allow_password_change", default: false
    t.text "tokens"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  create_table "versions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "model_id", null: false
    t.string "name", null: false
    t.string "origin"
    t.string "transmission"
    t.string "fuel_type"
    t.integer "seats"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "engine_capacity"
    t.integer "car_name_encoded"
    t.index ["model_id", "name"], name: "index_versions_on_model_id_and_name", unique: true
    t.index ["model_id"], name: "index_versions_on_model_id"
  end

  add_foreign_key "comments", "sale_posts"
  add_foreign_key "comments", "users"
  add_foreign_key "favorites", "sale_posts"
  add_foreign_key "favorites", "users"
  add_foreign_key "models", "brands"
  add_foreign_key "prediction_histories", "users"
  add_foreign_key "reports", "users", column: "reporter_id"
  add_foreign_key "sale_post_images", "sale_posts"
  add_foreign_key "sale_posts", "brands"
  add_foreign_key "sale_posts", "models"
  add_foreign_key "sale_posts", "users"
  add_foreign_key "sale_posts", "versions"
  add_foreign_key "versions", "models"
end
