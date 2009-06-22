class Sensor < ActiveRecord::Base
  set_table_name 'sensor' 
  has_many :events, :class_name => "event", :foreign_key => "sid"
  
end
