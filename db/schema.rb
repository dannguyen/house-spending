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

ActiveRecord::Schema.define(version: 20140119221910) do

  create_table "expenditures", force: true do |t|
    t.string   "bioguide_id"
    t.string   "office"
    t.string   "quarter"
    t.string   "category"
    t.date     "date"
    t.string   "payee"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "purpose"
    t.decimal  "amount"
    t.string   "year"
    t.string   "transcode"
    t.string   "transcodelong"
    t.string   "recordid"
    t.string   "recip_orig"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "expenditures", ["bioguide_id"], name: "index_expenditures_on_bioguide_id"

  create_table "members", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_name"
    t.datetime "birthday"
    t.string   "gender"
    t.string   "religion"
    t.string   "chamber"
    t.string   "party"
    t.string   "senate_class"
    t.integer  "district",           limit: 3
    t.string   "state"
    t.string   "state_seniority"
    t.date     "term_start_date"
    t.date     "term_end_date"
    t.string   "url"
    t.string   "rss_url"
    t.string   "office_address"
    t.string   "office_phone"
    t.string   "office_fax"
    t.string   "contact_form"
    t.string   "office_name"
    t.string   "facebook_id"
    t.string   "twitter_id"
    t.string   "youtube_id"
    t.string   "bioguide_id",        limit: 10
    t.string   "thomas_id"
    t.string   "govtrack_id"
    t.string   "opensecrets_id"
    t.string   "votesmart_id"
    t.string   "icpsr_id"
    t.string   "fec_ids"
    t.string   "cspan_id"
    t.string   "wikipedia_id"
    t.string   "house_history_id"
    t.string   "ballotpedia_id"
    t.string   "maplight_id"
    t.string   "washington_post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "members", ["chamber"], name: "index_members_on_chamber"
  add_index "members", ["state", "district"], name: "index_members_on_state_and_district"

  create_table "terms", force: true do |t|
    t.string   "chamber"
    t.integer  "congress_number"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "state"
    t.string   "party"
    t.integer  "district",        limit: 3
    t.string   "senate_class"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "member_id"
    t.string   "bioguide_id"
  end

  add_index "terms", ["member_id"], name: "index_terms_on_member_id"

end
