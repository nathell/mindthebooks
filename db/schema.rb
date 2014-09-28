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

ActiveRecord::Schema.define(version: 20140917103523) do

  create_table "books", force: true do |t|
    t.integer  "card_info_id"
    t.integer  "library_id"
    t.integer  "library_loan_id"
    t.string   "title"
    t.string   "author"
    t.date     "due_date"
    t.string   "fine"
    t.integer  "renew_count"
    t.datetime "last_renewed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "card_infos", force: true do |t|
    t.integer  "card_id"
    t.string   "cardholder"
    t.string   "charges"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cards", force: true do |t|
    t.integer  "user_id"
    t.string   "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
