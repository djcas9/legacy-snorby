class AddRtypeToReport < ActiveRecord::Migration
  def self.up
    add_column :reports, :rtype, :string
  end

  def self.down
    remove_column :reports, :rtype
  end
end
