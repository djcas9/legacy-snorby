class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.string :title
      t.string :from_time
      t.string :rtype
      t.timestamps
    end
  end
  
  def self.down
    drop_table :reports
  end
end
