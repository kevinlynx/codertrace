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

ActiveRecord::Schema.define(:version => 20120222024123) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "entries", :force => true do |t|
    t.string   "url"
    t.string   "tag"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",       :default => "no title"
    t.string   "description", :default => "no description"
    t.integer  "completed"
    t.string   "rss_url"
  end

  create_table "feeds", :force => true do |t|
    t.string   "url"
    t.text     "content",     :limit => 4294967295
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "download_at"
  end

  create_table "job_progresses", :force => true do |t|
    t.integer  "sum",        :default => 0
    t.integer  "finished",   :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "micro_posts", :force => true do |t|
    t.text     "description", :limit => 4294967295
    t.string   "url"
    t.string   "title"
    t.integer  "user_id"
    t.datetime "pub_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tag"
  end

  add_index "micro_posts", ["user_id"], :name => "index_micro_posts_on_user_id"

  create_table "process_jobs", :force => true do |t|
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",                    :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",                    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "description"
    t.datetime "posts_update_at",                       :default => '1986-01-01 00:00:00'
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "wait_feed_caches", :force => true do |t|
    t.string   "url"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
