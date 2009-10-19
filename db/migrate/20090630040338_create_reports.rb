class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.string :title
      t.integer :event_count, :default => 0
      t.string :from_time
      t.string :to_time
      t.string :rtype
      t.timestamps
    end
  end
  
  def self.down
    drop_table :reports
  end
end
