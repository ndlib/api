class AddClassNameToServices < ActiveRecord::Migration
  def change

    add_column :services, :service_class, :string

  end
end
