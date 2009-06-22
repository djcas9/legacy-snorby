class SigReference < ActiveRecord::Base
  set_table_name 'sig_reference'
  set_primary_key "sig_id"
  has_many :events, :foreign_key => 'signature'
end
