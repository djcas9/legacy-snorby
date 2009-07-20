class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :sid
      t.integer :cid
      t.string :comment_time
      t.text :body
      t.integer :user_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :comments
  end
end
