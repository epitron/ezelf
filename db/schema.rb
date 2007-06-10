# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 7) do

  create_table "albums", :force => true do |t|
    t.column "name",         :string
    t.column "artist_id",    :integer
    t.column "year",         :integer
    t.column "tracks_count", :integer
    t.column "various",      :boolean, :default => false
  end

  add_index "albums", ["artist_id"], :name => "index_albums_on_artist_id"
  add_index "albums", ["name"], :name => "index_albums_on_name"

  create_table "artists", :force => true do |t|
    t.column "name",         :string
    t.column "albums_count", :integer
  end

  add_index "artists", ["name"], :name => "index_artists_on_name"

  create_table "login_histories", :force => true do |t|
    t.column "user_id",     :integer
    t.column "date",        :datetime
    t.column "ip",          :string
    t.column "hostname",    :string
    t.column "system_info", :string
  end

  add_index "login_histories", ["user_id"], :name => "index_login_histories_on_user_id"

  create_table "playlists", :force => true do |t|
    t.column "name",    :string
    t.column "user_id", :integer
  end

  add_index "playlists", ["user_id"], :name => "index_playlists_on_user_id"

  create_table "playlists_tracks", :id => false, :force => true do |t|
    t.column "playlist_id", :integer
    t.column "track_id",    :integer
  end

  add_index "playlists_tracks", ["track_id"], :name => "index_playlists_tracks_on_track_id"
  add_index "playlists_tracks", ["playlist_id"], :name => "index_playlists_tracks_on_playlist_id"

  create_table "sessions", :force => true do |t|
    t.column "session_id", :string
    t.column "data",       :text
    t.column "updated_at", :datetime
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"

  create_table "tracks", :force => true do |t|
    t.column "title",    :string
    t.column "file",     :string
    t.column "album_id", :integer
    t.column "number",   :integer
    t.column "disc",     :integer
  end

  add_index "tracks", ["title"], :name => "index_tracks_on_title"
  add_index "tracks", ["file"], :name => "index_tracks_on_file"
  add_index "tracks", ["album_id"], :name => "index_tracks_on_album_id"
  add_index "tracks", ["number"], :name => "index_tracks_on_number"

  create_table "users", :force => true do |t|
    t.column "name",       :string
    t.column "password",   :string
    t.column "fullname",   :string
    t.column "email",      :string
    t.column "created_at", :string
  end

  add_index "users", ["name"], :name => "index_users_on_name"

end
