class CreateSearches < ActiveRecord::Migration
  def self.up
    create_table :searches do |t|
      t.string :title
      t.string :keywords
      t.integer :sid
      t.integer :sid_class_id
      t.string :ip_src
      t.string :ip_dst
      t.integer :sport
      t.integer :dport
      t.integer :sig_priority
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :show_search, :null => false
      t.timestamps
    end
    
    add_index :searches, :sid
    add_index :searches, :sid_class_id
    add_index :searches, :ip_src
    add_index :searches, :ip_dst
    add_index :searches, :sport
    add_index :searches, :dport
    add_index :searches, :sig_priority
    
  end
  
  def self.down
    drop_table :searches
  end
end
