class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.integer :events_per_page
      t.boolean :accept_email
      t.boolean :super_user
      t.integer :user_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :settings
  end
end
