class Admin::ConsumerService < ActiveRecord::Base

  belongs_to :consumer
  belongs_to :service

end
