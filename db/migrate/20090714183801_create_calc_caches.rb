class CreateCalcCaches < ActiveRecord::Migration
  def self.up
    create_table :calc_caches do |t|
      t.string :last_cache
      t.integer :high_severity, :default => 0
      t.integer :medium_severity, :default => 0
      t.integer :low_severity, :default => 0
      t.integer :total_event_count, :default => 0
      t.integer :unique_event_count, :default => 0
      t.integer :unique_address_count, :default => 0
      t.integer :last_cid, :default => 0
      t.text :sensor_cache
      t.text :category_cache
    end
  end
  
  def self.down
    drop_table :calc_caches
  end
end
