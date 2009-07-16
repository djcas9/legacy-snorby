class CreateTunes < ActiveRecord::Migration
  def self.up
    create_table :tunes do |t|
      t.string :sensor
      t.string :event_name
      t.integer :sid
      t.integer :cid
      t.string :tuned_at

      t.timestamps
    end
  end

  def self.down
    drop_table :tunes
  end
end
