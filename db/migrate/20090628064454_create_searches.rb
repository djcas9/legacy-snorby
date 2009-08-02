class CreateSearches < ActiveRecord::Migration
  def self.up
    create_table :searches do |t|
      t.string :keywords
      t.integer :sid
      t.integer :sid_class_id
      t.string :ip_src
      t.string :ip_dst
      t.integer :sport
      t.integer :dport
      t.integer :sig_priority
      t.integer :result_count
      t.datetime :start_time
      t.datetime :end_time
      t.timestamps
    end
  end
  
  def self.down
    drop_table :searches
  end
end
