class CreateCachedStats < ActiveRecord::Migration
  def self.up
    create_table :cached_stats do |t|
      t.string :type

      t.integer :duration_key
      t.string :name
      t.integer :statistic

      t.integer :sid

      t.timestamp :started_at
      t.timestamp :stopped_at
      t.timestamps
    end
  end

  def self.down
    drop_table :cached_stats
  end
end
