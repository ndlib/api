class Admin::User < ActiveRecord::Base
  # attr_accessible :name, :username
  devise :omniauthable, omniauth_providers: [:oktaoauth]

  validates :username, :uniqueness => true

end
