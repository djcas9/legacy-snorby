class Signature < ActiveRecord::Base
  set_table_name 'signature'
  set_primary_key "sig_id"
  has_many :events, :foreign_key => 'signature'
end
