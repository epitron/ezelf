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
  #include Clearance::User
  has_many :playlists
  has_many :listenings
  has_many :logins, :class_name => 'LoginHistory'

  ########################################################################
  ## Elf Things
  ########################################################################

  def last_login
    LoginHistory.find :first, :order=>"date desc"
  end

  def default_upload_dir
    "#{SETTINGS[:uploads_root]}/#{self.name}"
  end

  def upload_dir
    File.expand_path( @attributes["upload_dir"] || default_upload_dir )
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
    if valid_upload_dir?
      dir_tree(self.upload_dir)
    else
      []
    end
  end


  ########################################################################
  ## Validation Stuff
  ########################################################################

  validates_presence_of     :name, :email
  validates_uniqueness_of   :name, :email, :case_sensitive => false
  validates_length_of       :name, :within => 3..40
  validates_length_of       :email, :within => 3..100
  validates_length_of       :password, :within => 4..40

end
