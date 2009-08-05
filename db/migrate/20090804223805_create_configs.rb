class CreateConfigs < ActiveRecord::Migration
  def self.up
    create_table :configs do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :configs
  end
end
