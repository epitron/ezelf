# TODO: make this polymorphic, so you can put artists or albums or tracks in the playlist.

class Playlist < ActiveRecord::Base
	has_and_belongs_to_many :tracks
	belongs_to :user
end
