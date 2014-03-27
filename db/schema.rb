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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140324192514) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "lighthouse_tickets", force: true do |t|
    t.integer  "number"
    t.string   "state"
    t.string   "title"
    t.string   "url",                         limit: 256
    t.string   "body",                        limit: 20480
    t.integer  "assigned_lighthouse_user_id"
    t.integer  "lighthouse_user_id"
    t.datetime "ticket_created_at"
    t.datetime "ticket_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lighthouse_tickets", ["assigned_lighthouse_user_id"], name: "index_lighthouse_tickets_on_assigned_lighthouse_user_id", using: :btree
  add_index "lighthouse_tickets", ["lighthouse_user_id"], name: "index_lighthouse_tickets_on_lighthouse_user_id", using: :btree
  add_index "lighthouse_tickets", ["number"], name: "index_lighthouse_tickets_on_number", using: :btree
  add_index "lighthouse_tickets", ["state"], name: "index_lighthouse_tickets_on_state", using: :btree
  add_index "lighthouse_tickets", ["url"], name: "index_lighthouse_tickets_on_url", using: :btree

  create_table "lighthouse_users", force: true do |t|
    t.string   "job"
    t.string   "name"
    t.string   "namespace"
    t.string   "token"
    t.integer  "lighthouse_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lighthouse_users", ["job"], name: "index_lighthouse_users_on_job", using: :btree
  add_index "lighthouse_users", ["lighthouse_id"], name: "index_lighthouse_users_on_lighthouse_id", using: :btree
  add_index "lighthouse_users", ["name"], name: "index_lighthouse_users_on_name", using: :btree
  add_index "lighthouse_users", ["namespace"], name: "index_lighthouse_users_on_namespace", using: :btree
  add_index "lighthouse_users", ["token"], name: "index_lighthouse_users_on_token", using: :btree

end
