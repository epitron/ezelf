# == Schema Information
# Schema version: 10
#
# Table name: playlists
#
#  id      :integer(11)   not null, primary key
#  name    :string(255)   
#  user_id :integer(11)   
#

# TODO: make this polymorphic, so you can put artists or albums or tracks in the playlist.

class Playlist < ActiveRecord::Base
	has_and_belongs_to_many :tracks
	belongs_to :user
end
