class UpdateServices < ActiveRecord::Migration
  def up
    Admin::Service.update_all :service_class => 'Organization', :service_class => 'Org::Base'
  end

  def down
    Admin::Service.update_all :service_class => 'Org::Base', service_class => 'Organization'
  end

  class Admin::Service < ActiveRecord::Base
  end
end
