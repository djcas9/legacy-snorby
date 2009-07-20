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
  
end
