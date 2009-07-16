class User < ActiveRecord::Base
  acts_as_authentic
  has_many :settings
  has_many :event_options


  def self.who_accepts_email
    emails = []
    self.all.each do |user|
      emails << user.email if user.accept_email
    end
    return emails
  end
  
end
