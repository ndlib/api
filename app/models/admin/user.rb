class Admin::User < ActiveRecord::Base
  # attr_accessible :name, :username

  devise :cas_authenticatable, :trackable

  validates :username, :uniqueness => true

end
