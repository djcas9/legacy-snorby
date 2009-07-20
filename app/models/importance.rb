class Importance < ActiveRecord::Base
  set_primary_keys :sid, :cid
  belongs_to :event, :foreign_key => [:sid, :cid]
  belongs_to :user


  def self.all_event_for_user(user)
    @important_items = user.importance
    @events = []
    for item in @important_items
      @events << item.event
    end
    return @events.sort_by {|x| x.sig.sig_priority}
  end

end
