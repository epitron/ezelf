class Folder < ActiveRecord::Base
  has_many :children
  belongs_to :parent

  has_many :tracks
end
