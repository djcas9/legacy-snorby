class Comment < ActiveRecord::Base
  belongs_to :event, :foreign_key => [:sid, :cid]
  belongs_to :user
end
