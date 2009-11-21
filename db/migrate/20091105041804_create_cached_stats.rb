class CreateCachedStats < ActiveRecord::Migration
  def self.up
    create_table :cached_stats do |t|
      t.string :type

      t.string :name
      t.integer :start_cid, :default => 1
      t.integer :last_cid, :default => 0
      t.integer :statistic
      t.integer :expiration

      t.timestamps
    end
  end

  def self.down
    drop_table :cached_stats
  end
end
