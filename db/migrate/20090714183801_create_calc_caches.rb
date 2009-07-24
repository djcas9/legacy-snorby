class CreateCalcCaches < ActiveRecord::Migration
  def self.up
    create_table :calc_caches do |t|
      t.string :last_cache
      t.integer :high_severity, :null => 0
      t.integer :medium_severity, :null => 0
      t.integer :low_severity, :null => 0
      t.integer :total_event_count, :null => 0
      t.integer :unique_event_count, :null => 0
      t.integer :unique_address_count, :null => 0
      t.text :sensor_cache
      t.text :category_cache
      
      t.timestamps
    end
  end
  
  #CalcCache.build_cache

  def self.down
    drop_table :calc_caches
  end
end
