# == Schema Information
# Schema version: 18
#
# Table name: users
#
#  id         :integer(11)   not null, primary key
#  name       :string(255)   
#  password   :string(255)   
#  fullname   :string(255)   
#  email      :string(255)   
#  created_at :string(255)   
#  validated  :boolean(1)    
#  upload_dir :string(255)   
#

class User < ActiveRecord::Base
  has_many :playlists
  has_many :logins, :class_name => 'LoginHistory'

  def last_login
    LoginHistory.find :first, :order=>"date desc"
  end

  def default_upload_dir
    dir = "/dump/ftp/#{self.name}"

    if File.exists? dir
      return dir
    else
      raise "Error: Upload dir #{dir} doesn't exist."
    end
  end

  def upload_dir
    @attributes["upload_dir"] || default_upload_dir
  end

  def tree_of_uploaded_files
    dir_tree(self.upload_dir)
  end

end
