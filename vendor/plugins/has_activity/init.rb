# Include hook code here
require 'has_activity'
ActiveRecord::Base.send(:include, Elctech::Has::Activity)