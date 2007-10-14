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

  ########################################################################
  ## Elf Things
  ########################################################################

  def last_login
    LoginHistory.find :first, :order=>"date desc"
  end

  def default_upload_dir
    root = SETTINGS.root_of_upload_dirs || '/dump/ftp'
    dir = "#{root}/#{self.login}"

    if File.exists? dir
      dir
    else
      #raise "Error: Upload dir #{dir} doesn't exist."
      nil
    end
  end

  def upload_dir
    @attributes["upload_dir"] || default_upload_dir
  end

  def tree_of_uploaded_files
    dir_tree(self.upload_dir)
  end


  ########################################################################
  ## Authentication Stuff
  ########################################################################

  attr_protected :activated_at

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false

  
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    user = find_by_login(login) # need to get the salt
    
    if user and user.password == password and user.activated_at
      user 
    else
      nil
    end
  end

  def activate
    @activated = true
    update_attributes(:activated_at => Time.now.utc, :activation_code => nil)
  end

  def recently_activated?
    @activated
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    #crypted_password == encrypt(password)
    self.password == password
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end


protected
=begin
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
=end
    
  def password_required?
    #crypted_password.blank? || !password.blank?
    !password.blank?
  end

  def make_activation_code
    self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end

end
