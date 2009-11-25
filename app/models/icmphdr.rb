class Icmphdr < ActiveRecord::Base
  set_table_name 'icmphdr' 
  set_primary_keys :sid, :cid
  belongs_to :event, :foreign_key => [:sid, :cid]
end
