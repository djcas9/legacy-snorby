class Event < ActiveRecord::Base
  set_table_name 'event'
  belongs_to :sensor, :class_name => "Sensor", :foreign_key => "sid"
  
end
