class Admin::Consumer < ActiveRecord::Base

  devise :token_authenticatable, :trackable

  # attr_accessible :name, :description, :set_services, :authentication_token

  before_save :ensure_authentication_token!

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :consumer_services
  has_many :services, :through => :consumer_services


  def set_services=(vals)
    self.services = vals.collect {| v | Admin::Service.find(v) }
  end

  def can_access_service?(service)
    services.include?(service)
  end
end
