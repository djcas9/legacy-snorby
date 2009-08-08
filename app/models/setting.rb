class Setting < ActiveRecord::Base
  validates_presence_of :device_name
  private_class_method :new, :create, :destroy, :destroy_all, :delete, :delete_all
  
  @@s = find(:first)

  def self.method_missing(method, *args)
    option = method.to_s
    if option.include? '='
        var_name = option.gsub('=', '')
        value = args.first
        @@s[var_name] = value
      else
        @@s[option]
    end
  end
  
  def self.save
    @@s.save
  end

  def self.update_attributes(attributes)
    @@s.update_attributes(attributes)
  end

  def self.errors
    @@s.errors
  end
  
end
