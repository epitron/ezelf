class Admin::UsersController < AdminController
  active_scaffold :users do |config|
    config.columns = [:name, :fullname, :email, :password, :upload_dir, :validated]
  end
end
