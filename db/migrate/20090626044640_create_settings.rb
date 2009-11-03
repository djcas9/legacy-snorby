class CreateSettings < ActiveRecord::Migration
  
  def self.up
    create_table :settings do |t|
      t.string :app_name, :default => 'Snorby'
      t.string :app_dev, :default => 'Dustin Willis Webber'
      t.string :app_website, :default => 'http://www.snorby.org'
      t.string :device_name, :default => 'Snorby'
      t.integer :events_per_page, :default => '20'
      t.datetime :updated_at
      t.string :logo_file_name
      t.string :logo_content_type
      t.integer :logo_file_size
      t.datetime :logo_updated_at
    end
    
    execute "Insert into settings (app_name, app_dev, app_website, device_name, events_per_page) Values ('Snorby', 'Dustin Willis Webber', 'http://www.snorby.org', 'Snorby', '20')"
    
  end

  def self.down
    drop_table :settings
  end
  
end
