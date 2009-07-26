class Comment < ActiveRecord::Base
  belongs_to :event, :foreign_key => [:sid, :cid]
  belongs_to :user
  validates_presence_of :body, :message => "Comment Can't be blank"
end
