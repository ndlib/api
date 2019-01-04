class AddCodeToServices < ActiveRecord::Migration
  def change
    add_column :services, :code, :string
    add_index :services, :code
  end
end
