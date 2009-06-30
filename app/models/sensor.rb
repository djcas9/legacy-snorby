class Sensor < ActiveRecord::Base
  set_table_name 'sensor'
  set_primary_key "sid"
  has_many :events, :foreign_key => 'sid', :dependent => :destroy
  
  def encoding_type
    Encoding.find_by_encoding_type(self.encoding).encoding_text
  end
  
end
