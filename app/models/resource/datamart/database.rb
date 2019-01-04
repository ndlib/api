class Resource::Datamart::Database < ActiveRecord::Base
  establish_connection "dm_#{Rails.env}".to_sym

  @abstract_class = true

  # This application should not be writing to the datamart database
  def readonly?
    true
  end

end
