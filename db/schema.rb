# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 19) do

  create_table "albums", :force => true do |t|
    t.string   "name"
    t.integer  "artist_id"
    t.integer  "year"
    t.integer  "tracks_count", :default => 0
    t.boolean  "compilation",  :default => false
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "albums", ["updated_at"], :name => "index_albums_on_updated_at"
  add_index "albums", ["name"], :name => "index_albums_on_name"
  add_index "albums", ["artist_id"], :name => "index_albums_on_artist_id"

  create_table "artists", :force => true do |t|
    t.string   "name"
    t.integer  "albums_count", :default => 0
    t.integer  "tracks_count"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "artists", ["updated_at"], :name => "index_artists_on_updated_at"
  add_index "artists", ["name"], :name => "index_artists_on_name"

  create_table "encodings", :force => true do |t|
    t.string "name"
    t.string "description"
  end

  create_table "login_histories", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.string   "ip"
    t.string   "hostname"
    t.string   "system_info"
  end

  add_index "login_histories", ["user_id"], :name => "index_login_histories_on_user_id"

  create_table "playlists", :force => true do |t|
    t.string  "name"
    t.integer "user_id"
  end

  add_index "playlists", ["user_id"], :name => "index_playlists_on_user_id"

  create_table "playlists_tracks", :id => false, :force => true do |t|
    t.integer "playlist_id"
    t.integer "track_id"
  end

  add_index "playlists_tracks", ["playlist_id"], :name => "index_playlists_tracks_on_playlist_id"
  add_index "playlists_tracks", ["track_id"], :name => "index_playlists_tracks_on_track_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"
  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"

  create_table "similar_artists", :force => true do |t|
    t.integer  "artist_id"
    t.text     "similar_cache"
    t.datetime "updated_at"
  end

  add_index "similar_artists", ["artist_id"], :name => "index_similar_artists_on_artist_id"

  create_table "sources", :force => true do |t|
    t.string  "name"
    t.string  "description"
    t.string  "uri"
    t.integer "encoding_id", :default => 1
  end

  create_table "tracks", :force => true do |t|
    t.string   "title"
    t.integer  "album_id"
    t.string   "number",        :limit => 10
    t.integer  "disc"
    t.integer  "artist_id"
    t.string   "relative_path"
    t.string   "filename"
    t.integer  "source_id"
    t.float    "length"
    t.integer  "bitrate"
    t.boolean  "vbr"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.integer  "bytes"
    t.datetime "ctime"
    t.datetime "mtime"
  end

  add_index "tracks", ["updated_at"], :name => "index_tracks_on_updated_at"
  add_index "tracks", ["source_id"], :name => "index_tracks_on_source_id"
  add_index "tracks", ["filename"], :name => "index_tracks_on_filename"
  add_index "tracks", ["relative_path"], :name => "index_tracks_on_relative_path"
  add_index "tracks", ["number"], :name => "index_tracks_on_number"
  add_index "tracks", ["album_id"], :name => "index_tracks_on_album_id"
  add_index "tracks", ["title"], :name => "index_tracks_on_title"

  create_table "users", :force => true do |t|
    t.string  "name"
    t.string  "password"
    t.string  "fullname"
    t.string  "email"
    t.string  "created_at"
    t.boolean "validated",  :default => false
    t.string  "upload_dir"
  end

  add_index "users", ["name"], :name => "index_users_on_name"

end
