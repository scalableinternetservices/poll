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

ActiveRecord::Schema.define(version: 20151129221856) do

  create_table "answers", force: :cascade do |t|
    t.integer  "poll_question_id", limit: 4
    t.text     "text",             limit: 65535
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "votes",            limit: 4,     default: 0
  end

  add_index "answers", ["poll_question_id"], name: "index_answers_on_poll_question_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.string   "commenter",    limit: 255
    t.text     "body",         limit: 65535
    t.integer  "user_poll_id", limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "comments", ["user_poll_id"], name: "index_comments_on_user_poll_id", using: :btree

  create_table "friendships", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "friend_id",  limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "friendships", ["friend_id"], name: "index_friendships_on_friend_id", using: :btree
  add_index "friendships", ["user_id"], name: "index_friendships_on_user_id", using: :btree

  create_table "pending_friendships", force: :cascade do |t|
    t.integer  "requestor_id", limit: 4
    t.integer  "receiver_id",  limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "pending_friendships", ["receiver_id"], name: "index_pending_friendships_on_receiver_id", using: :btree
  add_index "pending_friendships", ["requestor_id"], name: "index_pending_friendships_on_requestor_id", using: :btree

  create_table "poll_questions", force: :cascade do |t|
    t.integer  "user_poll_id",                       limit: 4
    t.text     "text",                               limit: 65535
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.boolean  "optional"
    t.boolean  "allow_multiple_answers"
    t.string   "poll_question_picture_file_name",    limit: 255
    t.string   "poll_question_picture_content_type", limit: 255
    t.integer  "poll_question_picture_file_size",    limit: 4
    t.datetime "poll_question_picture_updated_at"
  end

  add_index "poll_questions", ["user_poll_id"], name: "index_poll_questions_on_user_poll_id", using: :btree

  create_table "shared_polls", force: :cascade do |t|
    t.integer  "sharee_id",    limit: 4
    t.integer  "sharer_id",    limit: 4
    t.integer  "user_poll_id", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "shared_polls", ["sharee_id"], name: "index_shared_polls_on_sharee_id", using: :btree
  add_index "shared_polls", ["sharer_id"], name: "index_shared_polls_on_sharer_id", using: :btree
  add_index "shared_polls", ["user_poll_id"], name: "index_shared_polls_on_user_poll_id", using: :btree

  create_table "user_polls", force: :cascade do |t|
    t.integer  "user_id",                   limit: 4
    t.string   "title",                     limit: 255
    t.text     "description",               limit: 65535
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "poll_picture_file_name",    limit: 255
    t.string   "poll_picture_content_type", limit: 255
    t.integer  "poll_picture_file_size",    limit: 4
    t.datetime "poll_picture_updated_at"
  end

  add_index "user_polls", ["user_id"], name: "index_user_polls_on_user_id", using: :btree

  create_table "user_votes", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.integer  "user_poll_id", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "user_votes", ["user_id"], name: "index_user_votes_on_user_id", using: :btree
  add_index "user_votes", ["user_poll_id"], name: "index_user_votes_on_user_poll_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                        limit: 255,   default: "", null: false
    t.string   "encrypted_password",           limit: 255,   default: "", null: false
    t.string   "reset_password_token",         limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                limit: 4,     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",           limit: 255
    t.string   "last_sign_in_ip",              limit: 255
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.text     "description",                  limit: 65535
    t.string   "first_name",                   limit: 255
    t.string   "last_name",                    limit: 255
    t.string   "profile_picture_file_name",    limit: 255
    t.string   "profile_picture_content_type", limit: 255
    t.integer  "profile_picture_file_size",    limit: 4
    t.datetime "profile_picture_updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "answers", "poll_questions"
  add_foreign_key "comments", "user_polls"
  add_foreign_key "friendships", "users"
  add_foreign_key "friendships", "users", column: "friend_id"
  add_foreign_key "pending_friendships", "users", column: "receiver_id"
  add_foreign_key "poll_questions", "user_polls"
  add_foreign_key "shared_polls", "user_polls"
  add_foreign_key "user_polls", "users"
  add_foreign_key "user_votes", "user_polls"
  add_foreign_key "user_votes", "users"
end
