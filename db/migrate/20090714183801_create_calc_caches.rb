class CreateCalcCaches < ActiveRecord::Migration
  def self.up
    create_table :calc_caches do |t|
      t.string :name
      t.integer :severity
      t.string :date
      t.integer :hour
      t.integer :count, :null => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :calc_caches
  end
end
