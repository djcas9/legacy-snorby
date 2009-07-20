class User < ActiveRecord::Base
  acts_as_authentic
  has_many :settings, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :importance, :dependent => :destroy


  def self.who_accepts_email
    emails = []
    self.all.each do |user|
      emails << user.email if user.accept_email
    end
    return emails
  end
  
  
  def self.is_admin_or_owner(user, object=nil)
    if user.admin?
      return true
    elsif user == object.user
      return true
    else
      false
    end
  end
  
end
