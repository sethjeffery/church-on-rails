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

ActiveRecord::Schema.define(version: 20170321173435) do

  create_table "actions", force: :cascade do |t|
    t.string   "action_type"
    t.integer  "actor_id"
    t.string   "actionable_type"
    t.integer  "actionable_id"
    t.text     "data"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["action_type", "created_at"], name: "index_actions_on_action_type_and_created_at"
    t.index ["actionable_type", "actionable_id"], name: "index_actions_on_actionable_type_and_actionable_id"
    t.index ["actor_id", "action_type"], name: "index_actions_on_actor_id_and_action_type"
    t.index ["actor_id"], name: "index_actions_on_actor_id"
  end

  create_table "child_group_checkins", force: :cascade do |t|
    t.integer  "child_group_membership_id"
    t.datetime "checked_in_at"
    t.datetime "checked_out_at"
    t.integer  "checked_in_by_id"
    t.integer  "checked_out_by_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["checked_in_by_id"], name: "index_child_group_checkins_on_checked_in_by_id"
    t.index ["checked_out_by_id"], name: "index_child_group_checkins_on_checked_out_by_id"
    t.index ["child_group_membership_id"], name: "index_child_group_checkins_on_child_group_membership_id"
  end

  create_table "child_group_memberships", force: :cascade do |t|
    t.integer  "child_group_id"
    t.integer  "person_id"
    t.boolean  "checked_in",     default: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["child_group_id"], name: "index_child_group_memberships_on_child_group_id"
    t.index ["person_id"], name: "index_child_group_memberships_on_person_id"
  end

  create_table "child_groups", force: :cascade do |t|
    t.string   "name"
    t.string   "age_group"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "church_processes", force: :cascade do |t|
    t.string   "name"
    t.string   "icon",        default: "arrow-right"
    t.text     "description"
    t.text     "steps"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "search_name"
  end

  create_table "churches", force: :cascade do |t|
    t.string   "name"
    t.string   "address1"
    t.string   "address2"
    t.string   "postcode"
    t.string   "country"
    t.string   "charity_number"
    t.string   "phone"
    t.string   "email"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.float    "latitude"
    t.float    "longitude"
    t.string   "cover_file_name"
    t.string   "cover_content_type"
    t.integer  "cover_file_size"
    t.datetime "cover_updated_at"
  end

  create_table "comments", force: :cascade do |t|
    t.text     "description"
    t.integer  "person_id"
    t.string   "commentable_type"
    t.integer  "commentable_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["person_id"], name: "index_comments_on_person_id"
  end

  create_table "events", force: :cascade do |t|
    t.integer  "author_id"
    t.integer  "team_id"
    t.string   "name"
    t.string   "address1"
    t.string   "address2"
    t.string   "postcode"
    t.string   "country"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.float    "latitude"
    t.float    "longitude"
    t.index ["author_id"], name: "index_events_on_author_id"
    t.index ["team_id"], name: "index_events_on_team_id"
  end

  create_table "families", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "postcode"
    t.string   "country"
    t.float    "latitude"
    t.float    "longitude"
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
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "email"
    t.string   "phone"
    t.string   "gender"
    t.string   "facebook"
    t.string   "twitter"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.date     "joined_at"
    t.string   "search_name"
    t.index ["first_name"], name: "index_people_on_first_name"
    t.index ["gender"], name: "index_people_on_gender"
    t.index ["last_name"], name: "index_people_on_last_name"
    t.index ["user_id"], name: "index_people_on_user_id"
  end

  create_table "person_process_assignees", force: :cascade do |t|
    t.integer  "assignee_id"
    t.integer  "person_process_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["assignee_id"], name: "index_person_process_assignees_on_assignee_id"
    t.index ["person_process_id"], name: "index_person_process_assignees_on_person_process_id"
  end

  create_table "person_processes", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "church_process_id"
    t.boolean  "complete"
    t.text     "steps"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["church_process_id"], name: "index_person_processes_on_church_process_id"
    t.index ["person_id"], name: "index_person_processes_on_person_id"
  end

  create_table "properties", force: :cascade do |t|
    t.string   "name"
    t.string   "format",      default: "flag"
    t.text     "list"
    t.string   "icon",        default: "property"
    t.string   "description"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "property_joins", force: :cascade do |t|
    t.string   "propertyable_type"
    t.integer  "propertyable_id"
    t.integer  "property_id"
    t.string   "value"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["property_id"], name: "index_property_joins_on_property_id"
    t.index ["propertyable_type", "propertyable_id"], name: "index_property_joins_on_propertyable_type_and_propertyable_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.string   "schedulable_type"
    t.integer  "schedulable_id"
    t.date     "date"
    t.time     "time"
    t.string   "rule"
    t.string   "interval"
    t.text     "day"
    t.text     "day_of_week"
    t.datetime "until"
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", force: :cascade do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_settings_on_key"
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
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.boolean  "admin",           default: false
    t.text     "description"
    t.string   "color",           default: "54aeea"
    t.boolean  "people_editor"
    t.boolean  "people_reader"
    t.boolean  "people_admin"
    t.string   "icon",            default: "team"
    t.boolean  "process_editor"
    t.boolean  "process_reader"
    t.boolean  "process_admin"
    t.boolean  "event_editor"
    t.boolean  "event_reader"
    t.boolean  "event_admin"
    t.boolean  "comment_editor"
    t.boolean  "comment_reader"
    t.boolean  "comment_admin"
    t.boolean  "children_editor"
    t.boolean  "children_reader"
    t.boolean  "children_admin"
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
