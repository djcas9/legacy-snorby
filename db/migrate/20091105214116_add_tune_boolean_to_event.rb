class AddTuneBooleanToEvent < ActiveRecord::Migration
  def self.up
    add_column :event, :tune, :boolean, :null => false
  end

  def self.down
    remove_column :event, :tune
  end
end
