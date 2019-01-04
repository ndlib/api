class DeviseCreateConsumers < ActiveRecord::Migration
  def change
    create_table(:consumers) do |t|
      t.string :name
      t.text :description
      
      ## Token authenticatable
      t.string :authentication_token

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.timestamps
    end

    add_index :consumers, :name, :unique => true
    add_index :consumers, :authentication_token, :unique => true
  end
end
