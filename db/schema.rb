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

ActiveRecord::Schema.define(version: 20130308003805) do

  create_table "lighthouse_tickets", force: true do |t|
    t.string   "service"
    t.integer  "number"
    t.string   "status"
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

  add_index "lighthouse_tickets", ["assigned_lighthouse_user_id"], name: "index_lighthouse_tickets_on_assigned_lighthouse_user_id"
  add_index "lighthouse_tickets", ["lighthouse_user_id"], name: "index_lighthouse_tickets_on_lighthouse_user_id"
  add_index "lighthouse_tickets", ["number"], name: "index_lighthouse_tickets_on_number"

  create_table "lighthouse_users", force: true do |t|
    t.string   "namespace"
    t.string   "token"
    t.integer  "lighthouse_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lighthouse_users", ["lighthouse_id"], name: "index_lighthouse_users_on_lighthouse_id"
  add_index "lighthouse_users", ["namespace"], name: "index_lighthouse_users_on_namespace"
  add_index "lighthouse_users", ["token"], name: "index_lighthouse_users_on_token"

end
