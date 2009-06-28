# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090628215615) do

  create_table "data", :id => false, :force => true do |t|
    t.integer "sid",          :null => false
    t.integer "cid",          :null => false
    t.text    "data_payload"
  end

  create_table "detail", :primary_key => "detail_type", :force => true do |t|
    t.text "detail_text", :null => false
  end

  create_table "encoding", :primary_key => "encoding_type", :force => true do |t|
    t.text "encoding_text", :null => false
  end

  create_table "event", :id => false, :force => true do |t|
    t.integer  "sid",       :null => false
    t.integer  "cid",       :null => false
    t.integer  "signature", :null => false
    t.datetime "timestamp", :null => false
  end

  add_index "event", ["signature"], :name => "sig"
  add_index "event", ["timestamp"], :name => "time"

  create_table "icmphdr", :id => false, :force => true do |t|
    t.integer "sid",                    :null => false
    t.integer "cid",                    :null => false
    t.integer "icmp_type", :limit => 1, :null => false
    t.integer "icmp_code", :limit => 1, :null => false
    t.integer "icmp_csum", :limit => 2
    t.integer "icmp_id",   :limit => 2
    t.integer "icmp_seq",  :limit => 2
  end

  add_index "icmphdr", ["icmp_type"], :name => "icmp_type"

  create_table "iphdr", :id => false, :force => true do |t|
    t.integer "sid",                   :null => false
    t.integer "cid",                   :null => false
    t.integer "ip_src",                :null => false
    t.integer "ip_dst",                :null => false
    t.integer "ip_ver",   :limit => 1
    t.integer "ip_hlen",  :limit => 1
    t.integer "ip_tos",   :limit => 1
    t.integer "ip_len",   :limit => 2
    t.integer "ip_id",    :limit => 2
    t.integer "ip_flags", :limit => 1
    t.integer "ip_off",   :limit => 2
    t.integer "ip_ttl",   :limit => 1
    t.integer "ip_proto", :limit => 1, :null => false
    t.integer "ip_csum",  :limit => 2
  end

  add_index "iphdr", ["ip_dst"], :name => "ip_dst"
  add_index "iphdr", ["ip_src"], :name => "ip_src"

  create_table "opt", :id => false, :force => true do |t|
    t.integer "sid",                    :null => false
    t.integer "cid",                    :null => false
    t.integer "optid",                  :null => false
    t.integer "opt_proto", :limit => 1, :null => false
    t.integer "opt_code",  :limit => 1, :null => false
    t.integer "opt_len",   :limit => 2
    t.text    "opt_data"
  end

  create_table "reference", :primary_key => "ref_id", :force => true do |t|
    t.integer "ref_system_id", :null => false
    t.text    "ref_tag",       :null => false
  end

  create_table "reference_system", :primary_key => "ref_system_id", :force => true do |t|
    t.string "ref_system_name", :limit => 20
  end

  create_table "schema", :primary_key => "vseq", :force => true do |t|
    t.datetime "ctime", :null => false
  end

  create_table "searches", :force => true do |t|
    t.string   "keywords"
    t.integer  "sid"
    t.integer  "sid_class_id"
    t.integer  "ip_src"
    t.integer  "ip_dst"
    t.integer  "sport"
    t.integer  "dport"
    t.integer  "sig_priority"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sensor", :primary_key => "sid", :force => true do |t|
    t.text    "hostname"
    t.text    "interface"
    t.text    "filter"
    t.integer "detail",    :limit => 1
    t.integer "encoding",  :limit => 1
    t.integer "last_cid",               :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "settings", :force => true do |t|
    t.boolean  "events_per_page"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sig_class", :primary_key => "sig_class_id", :force => true do |t|
    t.string "sig_class_name", :limit => 60, :null => false
  end

  add_index "sig_class", ["sig_class_id"], :name => "sig_class_id"
  add_index "sig_class", ["sig_class_name"], :name => "sig_class_name"

  create_table "sig_reference", :id => false, :force => true do |t|
    t.integer "sig_id",  :null => false
    t.integer "ref_seq", :null => false
    t.integer "ref_id",  :null => false
  end

  create_table "signature", :primary_key => "sig_id", :force => true do |t|
    t.string  "sig_name",     :null => false
    t.integer "sig_class_id", :null => false
    t.integer "sig_priority"
    t.integer "sig_rev"
    t.integer "sig_sid"
    t.integer "sig_gid"
  end

  add_index "signature", ["sig_class_id"], :name => "sig_class_id_idx"
  add_index "signature", ["sig_name"], :name => "sign_idx"

  create_table "tcphdr", :id => false, :force => true do |t|
    t.integer "sid",                    :null => false
    t.integer "cid",                    :null => false
    t.integer "tcp_sport", :limit => 2, :null => false
    t.integer "tcp_dport", :limit => 2, :null => false
    t.integer "tcp_seq"
    t.integer "tcp_ack"
    t.integer "tcp_off",   :limit => 1
    t.integer "tcp_res",   :limit => 1
    t.integer "tcp_flags", :limit => 1, :null => false
    t.integer "tcp_win",   :limit => 2
    t.integer "tcp_csum",  :limit => 2
    t.integer "tcp_urp",   :limit => 2
  end

  add_index "tcphdr", ["tcp_dport"], :name => "tcp_dport"
  add_index "tcphdr", ["tcp_flags"], :name => "tcp_flags"
  add_index "tcphdr", ["tcp_sport"], :name => "tcp_sport"

  create_table "udphdr", :id => false, :force => true do |t|
    t.integer "sid",                    :null => false
    t.integer "cid",                    :null => false
    t.integer "udp_sport", :limit => 2, :null => false
    t.integer "udp_dport", :limit => 2, :null => false
    t.integer "udp_len",   :limit => 2
    t.integer "udp_csum",  :limit => 2
  end

  add_index "udphdr", ["udp_dport"], :name => "udp_dport"
  add_index "udphdr", ["udp_sport"], :name => "udp_sport"

  create_table "users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login",                            :null => false
    t.string   "crypted_password",                 :null => false
    t.string   "password_salt",                    :null => false
    t.string   "persistence_token",                :null => false
    t.integer  "login_count",       :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
  end

  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"

end
