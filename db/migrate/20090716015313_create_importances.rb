class CreateImportances < ActiveRecord::Migration
  def self.up
    create_table :importances do |t|
      t.integer :sid
      t.integer :cid
      t.integer :user_id
      t.timestamps
    end

  end

  def self.down
    drop_table :importances
  end
end
