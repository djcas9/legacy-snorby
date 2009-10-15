class CreateImportances < ActiveRecord::Migration
  def self.up
    create_table :importances do |t|
      t.integer :sid
      t.integer :cid
      t.integer :user_id
      t.boolean :important, :default => 0, :null => false
      t.timestamps
    end
    
    add_index :importances, :sid
    add_index :importances, :cid
    add_index :importances, :user_id
  end

  def self.down
    drop_table :importances
  end
end
