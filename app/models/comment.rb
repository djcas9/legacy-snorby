class Comment < ActiveRecord::Base
  belongs_to :event, :foreign_key => [:sid, :cid]
  belongs_to :user
  validates_presence_of :body, :message => "Comment Can't be blank"
  
  named_scope :recent_comments, lambda {
  { :limit => 5, :order => 'created_at DESC' } }
  
end
