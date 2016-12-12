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

ActiveRecord::Schema.define(version: 20161207020007) do

  create_table "pixnet_articles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id",                       null: false
    t.integer  "origin_id",                     null: false, comment: "pixnet origin article id"
    t.string   "title"
    t.text     "content",    limit: 4294967295
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["origin_id"], name: "index_pixnet_articles_on_origin_id", using: :btree
    t.index ["user_id"], name: "index_pixnet_articles_on_user_id", using: :btree
  end

  create_table "pixnet_images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "article_id"
    t.string   "img"
    t.string   "url"
    t.string   "digest",     limit: 64
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["article_id"], name: "index_pixnet_images_on_article_id", using: :btree
    t.index ["digest"], name: "index_pixnet_images_on_digest", using: :btree
  end

  create_table "pixnet_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",                        null: false, comment: "pixnet username"
    t.integer  "article_count"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "account"
    t.text     "description",   limit: 65535
    t.string   "keyword"
    t.string   "site_category"
    t.string   "hits"
    t.string   "avatar"
  end

end
