class Data_Info < ActiveRecord::Base
  set_table_name 'data' 
  set_primary_keys :sid, :cid
  belongs_to :events, :foreign_key => [:sid, :cid]
end
