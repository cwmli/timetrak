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

ActiveRecord::Schema.define(version: 20150523014603) do

  create_table "accounts", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "remember_digest"
    t.string   "slug"
  end

  add_index "accounts", ["slug"], name: "index_accounts_on_slug", unique: true

  create_table "events", force: :cascade do |t|
    t.text     "description"
    t.text     "location"
    t.boolean  "notify"
    t.datetime "notifydate"
    t.string   "slug"
    t.date     "startdate"
    t.date     "enddate"
    t.time     "starttime"
    t.time     "endtime"
    t.integer  "team_id"
    t.string   "team1"
    t.string   "team2"
  end

  add_index "events", ["slug"], name: "index_events_on_slug", unique: true
  add_index "events", ["team_id"], name: "index_events_on_team_id"

  create_table "seasons", force: :cascade do |t|
    t.string   "title"
    t.string   "slug"
    t.integer  "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "seasons", ["account_id"], name: "index_seasons_on_account_id"
  add_index "seasons", ["slug"], name: "index_seasons_on_slug"

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "score"
    t.string   "slug"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "account_id"
    t.integer  "season_id"
  end

  add_index "teams", ["account_id"], name: "index_teams_on_account_id"
  add_index "teams", ["season_id"], name: "index_teams_on_season_id"
  add_index "teams", ["slug"], name: "index_teams_on_slug", unique: true

  create_table "venues", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
    t.string   "location"
    t.integer  "season_id"
    t.string   "slug"
  end

  add_index "venues", ["season_id"], name: "index_venues_on_season_id"

end
