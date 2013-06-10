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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130527070011) do

  create_table "assignments", :force => true do |t|
    t.integer  "user_id",           :null => false
    t.datetime "schedule_start_at", :null => false
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "assignments", ["user_id"], :name => "index_assignments_on_user_id"

  create_table "calendars", :force => true do |t|
    t.integer  "user_id",                                       :null => false
    t.string   "external_id", :limit => 100,                    :null => false
    t.string   "name",        :limit => 100,                    :null => false
    t.string   "time_zone",   :limit => 50,                     :null => false
    t.boolean  "selected",                   :default => false
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  add_index "calendars", ["external_id"], :name => "index_calendars_on_external_id", :unique => true
  add_index "calendars", ["user_id"], :name => "index_calendars_on_user_id"

  create_table "meetings", :force => true do |t|
    t.integer  "user_id",                                              :null => false
    t.integer  "assignment_id",                                        :null => false
    t.string   "external_id"
    t.string   "key",           :limit => 36,                          :null => false
    t.datetime "start_at",                                             :null => false
    t.datetime "end_at",                                               :null => false
    t.string   "state",                       :default => "suggested"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
  end

  add_index "meetings", ["key"], :name => "index_meetings_on_key", :unique => true
  add_index "meetings", ["start_at", "end_at"], :name => "index_meetings_on_start_at_and_end_at", :unique => true
  add_index "meetings", ["user_id", "assignment_id"], :name => "index_meetings_on_user_id_and_assignment_id"

  create_table "recipients", :force => true do |t|
    t.integer  "assignment_id", :null => false
    t.string   "email",         :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "recipients", ["assignment_id", "email"], :name => "index_recipients_on_assignment_id_and_email", :unique => true

  create_table "schedules", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.integer  "calendar_id", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "schedules", ["user_id", "calendar_id"], :name => "index_schedules_on_user_id_and_calendar_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "provider",             :limit => 15,  :null => false
    t.string   "uid",                  :limit => 25,  :null => false
    t.string   "token",                :limit => 64,  :null => false
    t.string   "refresh_token",        :limit => 64,  :null => false
    t.integer  "expires_at",                          :null => false
    t.string   "name",                 :limit => 100, :null => false
    t.string   "email",                               :null => false
    t.integer  "gender",               :limit => 2
    t.string   "locale",               :limit => 5
    t.string   "image"
    t.integer  "selected_calendar_id"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["provider", "uid"], :name => "index_users_on_provider_and_uid", :unique => true

end
