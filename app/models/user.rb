# == Schema Information
# Schema version: 20
#
# Table name: users
#
#  id         :integer       not null, primary key
#  name       :string(255)   
#  password   :string(255)   
#  fullname   :string(255)   
#  email      :string(255)   
#  created_at :string(255)   
#  validated  :boolean       
#  upload_dir :string(255)   
#

class User < ActiveRecord::Base
  has_many :playlists
  has_many :listenings
  has_many :logins, :class_name => 'LoginHistory'

  def last_login
    LoginHistory.find :first, :order=>"date desc"
  end

  def default_upload_dir
    "#{SETTINGS[:uploads_root]}/#{self.name}"
  end

  def upload_dir
    @attributes["upload_dir"] || default_upload_dir
  end

  def valid_upload_dir?
    File.exists? upload_dir

#    if File.exists? dir
#      return dir
#    else
#      raise "Error: Upload dir #{dir} doesn't exist."
#    end
  end

  def tree_of_uploaded_files
    dir_tree(self.upload_dir)
  end

end
