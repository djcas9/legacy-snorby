class Importance < ActiveRecord::Base
  belongs_to :event, :class_name => 'Event', :foreign_key => [:sid, :cid]
  belongs_to :user
end
