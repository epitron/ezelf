# == Schema Information
# Schema version: 22
#
# Table name: listenings
#
#  id          :integer(4)    not null, primary key
#  user_id     :integer(4)    
#  track_id    :integer(4)    
#  started_at  :datetime      
#  finished_at :datetime      
#

class Listening < ActiveRecord::Base
  belongs_to :user
  belongs_to :track
end
