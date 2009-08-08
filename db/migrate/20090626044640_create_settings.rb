class CreateSettings < ActiveRecord::Migration
  
  def self.up

    create_table :settings do |t|
      t.string :app_name
      t.string :app_dev
      t.string :app_website
      t.string :app_version
      t.string :device_name
      t.integer :events_per_page
      t.datetime :updated_at
    end
    
    execute "Insert into settings (app_name, app_dev, app_website, app_version, device_name, events_per_page) Values ('Snorby', 'Dustin Willis Webber', 'http://www.snorby.org', '1.1.0', 'Snorby', '20')"
    
  end

  def self.down
    drop_table :settings
  end
  
  
end
