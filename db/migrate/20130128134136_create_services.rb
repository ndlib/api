class CreateServices < ActiveRecord::Migration

  def change
    create_table(:services) do |t|
      t.string :name
      t.text :description
      t.text :parameters
      t.string :path
    end

    create_table :consumer_services do | t |
      t.integer :service_id
      t.integer :consumer_id
    end

  end

end
