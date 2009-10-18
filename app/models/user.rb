class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.login_field = :email
  end
  has_many :comments, :dependent => :destroy
  has_many :importance, :dependent => :destroy
  
  has_attached_file :avatar,
  :styles => { :menu_bar => "30x30", :small => "20x20#", :medium => "90x90#", :large => "500x500>" },
  :processors => [:cropper],
  :url  => "/assets/users/:id/:style/:basename.:extension",
  :path => ":rails_root/public/assets/users/:id/:style/:basename.:extension",
  :default_url => "/images/default/avatar.png"

  
  # Not Working
  #validates_attachment_size :avatar, :less_than => 5.megabytes
  #validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png', 'image/jpg']

  
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :reprocess_avatar, :if => :cropping?
  
  named_scope :admin, :conditions => ["admin = ?", true]
  named_scope :accept_email, :conditions => ["accept_email = ?", true]
  cattr_accessor :current_user
  
  def self.who_accepts_email
    emails = []
    #emails = User.accept_email.collect! {|x| x.email }
    self.all.each do |user|
      emails << user.email if user.accept_email
    end
    return emails
  end
  
  
  def self.is_admin_or_owner(user, comment_id=nil)
    comment = Comment.find(comment_id)
    if user.admin?
      return true
    elsif user == comment.user
      return true
    else
      false
    end
  end
  
  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def avatar_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(avatar.path(style))
  end

  private

  def reprocess_avatar
    avatar.reprocess!
  end
  
end
