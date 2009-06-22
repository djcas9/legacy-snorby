class Sensor < ActiveRecord::Base
  set_table_name 'sensor'
  set_primary_key "sid"
  has_many :events, :foreign_key => 'sid'
  
end
