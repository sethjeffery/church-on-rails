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

ActiveRecord::Schema.define(version: 20161117203251) do

  create_table "families", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "postcode"
    t.string   "country"
    t.index ["name"], name: "index_families_on_name"
  end

  create_table "family_memberships", force: :cascade do |t|
    t.integer  "family_id"
    t.integer  "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "head"
    t.index ["family_id"], name: "index_family_memberships_on_family_id"
    t.index ["person_id"], name: "index_family_memberships_on_person_id"
  end

  create_table "people", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "prefix"
    t.string   "suffix"
    t.string   "middle_name"
    t.date     "dob"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "email"
    t.string   "phone"
    t.string   "gender"
    t.index ["first_name"], name: "index_people_on_first_name"
    t.index ["last_name"], name: "index_people_on_last_name"
    t.index ["user_id"], name: "index_people_on_user_id"
  end

  create_table "team_memberships", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_team_memberships_on_person_id"
    t.index ["team_id"], name: "index_team_memberships_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "admin",         default: false
    t.text     "description"
    t.string   "color"
    t.boolean  "people_editor"
    t.boolean  "people_reader"
    t.boolean  "people_admin"
    t.index ["name"], name: "index_teams_on_name"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
