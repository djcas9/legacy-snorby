class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.timestamps
      t.string :name
      t.string :email, :null => false
      t.string :crypted_password, :null => false
      t.string :password_salt, :null => false
      t.string :persistence_token, :null => false
      t.integer :login_count, :default => 0, :null => false
      t.datetime :last_request_at
      t.datetime :last_login_at
      t.datetime :current_login_at
      t.string :last_login_ip
      t.string :current_login_ip
      t.string :setting_id
      t.boolean :resolve_ips, :null => true
      t.boolean :accept_email, :null => false
      t.boolean :admin, :null => false
    end
    
    add_column :users, :avatar_file_name, :string
    add_column :users, :avatar_content_type, :string
    add_column :users, :avatar_file_size, :integer
    add_column :users, :avatar_updated_at, :datetime
    
    add_index :users, :name
    add_index :users, :email
    add_index :users, :persistence_token
    add_index :users, :last_request_at
    
  end
 
  def self.down
    drop_table :users
  end
  
end