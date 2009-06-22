class Tcphdr < ActiveRecord::Base
  set_table_name 'tcphdr' 
  set_primary_keys :sid, :cid
  belongs_to :events, :foreign_key => [:sid, :cid]
end
