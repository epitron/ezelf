class Album < ActiveRecord::Base
    has_many :tracks, :order=>:number
    belongs_to :artist
end
