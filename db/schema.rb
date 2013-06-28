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

ActiveRecord::Schema.define(:version => 20130625170105) do

  create_table "administrativeunits", :force => true do |t|
    t.string  "identifier"
    t.string  "name"
    t.string  "code"
    t.string  "natcode"
    t.string  "levelname"
    t.string  "level"
    t.spatial "geom",       :limit => {:srid=>4258, :type=>"geometry"}
  end

  create_table "cadastralparcels", :force => true do |t|
    t.string  "identifier"
    t.string  "localid"
    t.float   "area"
    t.string  "label"
    t.string  "natref"
    t.spatial "geom",       :limit => {:srid=>4258, :type=>"geometry"}
  end

  create_table "mappings", :force => true do |t|
    t.integer "user_id"
    t.string  "mapping_type", :null => false
    t.text    "data",         :null => false
    t.string  "name"
  end

  create_table "pg_search_documents", :force => true do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "shapefiles", :force => true do |t|
    t.string   "identifier"
    t.integer  "version_id"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.string   "shapefile_file_name"
    t.string   "shapefile_content_type"
    t.integer  "shapefile_file_size"
    t.datetime "shapefile_updated_at"
    t.string   "condition",              :default => "UnExtracted"
    t.integer  "features",               :default => 0
    t.string   "faults"
    t.integer  "projection",             :default => 4236
    t.text     "note"
    t.string   "archive_path"
  end

  create_table "users", :force => true do |t|
    t.string   "email",              :default => "", :null => false
    t.string   "encrypted_password", :default => "", :null => false
    t.integer  "sign_in_count",      :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  create_table "versions", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "active",      :default => false
    t.boolean  "archived",    :default => false
    t.boolean  "staging",     :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "user_id"
  end

end
