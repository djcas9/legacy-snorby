class SigClass < ActiveRecord::Base
  set_table_name 'sig_class'
  set_primary_key "sig_class_id"
  has_many :sig, :class_name => "Signature", :foreign_key => 'sig_class_id'
  has_many :events, :through => :sig
end
