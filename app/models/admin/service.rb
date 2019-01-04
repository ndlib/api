class Admin::Service < ActiveRecord::Base
  # attr_accessible :name, :description, :parameters, :path, :service_class, :code

  has_many :consumers, :through => :consumer_services
  has_many :consumer_services

  scope :determine_service_from_path, lambda { | path | where("? LIKE path ", path) }

  validates :name, :path, :service_class, :code, presence: true


  def api
    self.service_class.constantize
  end

end
