require 'prawn/layout'
require 'prawn/format'

pdf.tags :h1 => { :font_size => "2em", :font_weight => :bold },
:h2 => { :font_size => "0.5em", :font_weight => :bold },
:title => { :font_weight => :bold, :font_size => "1.5em" },
:indent => { :width => "2em" },
:event_data => { :color => 'black', :align => :justify },
:event_title => { :color => 'black', :font_weight => :bold },
:high => { :color => "red", :align => :left },
:medium => { :color => 'yellow', :align => :left },
:low => { :color => 'green', :align => :left }
snorby_logo = "public/images/PDF/snorby_logo.png"
pdf.line_width(1)

### GET DATA

### END

### Start Of Cover

pdf.move_down(100)
pdf.image snorby_logo, :scale=>0.7, :position => :center
pdf.text "#{@event.sig.sig_name}", :size => 15, :style => :bold, :align => :center
pdf.text "This report was generated: #{Time.now.strftime('%A, %B %d, %Y')}", :size => 12, :style => :bold, :align => :center

pdf.move_down(30)
pdf.start_new_page

###



### END

### Start Of Data
pdf.header [pdf.margin_box.left, pdf.margin_box.top + 20] do
  pdf.text "- #{Time.now.strftime('%A, %B %d, %Y')} - #{@event.sig.sig_name}. -", :size => 7, :align => :center, :style => :italic, :color => 'black'
  pdf.move_down 2
  pdf.stroke_horizontal_rule
  pdf.move_down 30
end

pdf.footer [pdf.margin_box.left, pdf.margin_box.bottom + 5] do
  pdf.move_down 7
  pdf.stroke_horizontal_rule
  pdf.move_down 3
  pdf.text "- #{pdf.page_count} -", :size => 7, :align => :center
  pdf.move_down 1
  pdf.text "Copyright (c) Snorby.org", :size => 7, :align => :center, :style => :italic, :color => 'black'
end

if @event.blank?
  pdf.move_down(30)
  pdf.text "NO DATA", :size => 30, :style => :bold, :align => :center
end

pdf.move_down(30)
pdf.text "#{@event.sig.sig_name}", :size => 25, :style => :bold, :align => :left
pdf.move_down(10)
pdf.text "Sensor Information:", :size => 15, :style => :bold, :align => :left
a_header = ["Sensor", "Interface", "Hostname", "Event ID"]
pdf.table [[@event.sensor.id, @event.sensor.interface, @event.sensor.hostname, @event.id[1]]],
:headers => a_header,
:header_color => 'f8f8f8',
:header_text_color => "323233",
:padding => 5,
:border_style => :grid,
:position => :center,
:row_colors => ["FFFFFF", "e8f9ff"],
:width => 535,
:border_width => 1,
:font_size => 9


pdf.move_down(25)

pdf.text "IP Address Information:", :size => 15, :style => :bold, :align => :left
b_header = ["Source IP", "Destination IP"]
pdf.table [["#{IPAddr.new_ntoh([@event.iphdr.ip_src].pack('N'))}", "#{IPAddr.new_ntoh([@event.iphdr.ip_dst].pack('N'))}"]],
:headers => b_header,
:header_color => 'f8f8f8',
:header_text_color => "323233",
:padding => 5,
:border_style => :grid,
:position => :center,
:row_colors => ["FFFFFF", "e8f9ff"],
:width => 535,
:border_width => 1,
:font_size => 9

pdf.move_down(25)

c_header = ["Version", "Header Length", "Type of Service", "Length", "ID", "Flags", "Offset", "TTL", "Protocol", "Check Sum"]
pdf.table [[@event.iphdr.ip_ver, @event.iphdr.ip_hlen, @event.iphdr.ip_tos, @event.iphdr.ip_len, @event.iphdr.ip_id, @event.iphdr.ip_flags, @event.iphdr.ip_off, @event.iphdr.ip_ttl, @event.iphdr.ip_proto, @event.iphdr.ip_csum]],
:headers => c_header,
:header_color => 'f8f8f8',
:header_text_color => "323233",
:padding => 5,
:border_style => :grid,
:position => :center,
:row_colors => ["FFFFFF", "e8f9ff"],
:width => 535,
:border_width => 1,
:font_size => 9

unless @event.tcphdr.blank?
  pdf.move_down(25)
  pdf.text "TCP Information:", :size => 15, :style => :bold, :align => :left
  d_header = ["S. Port", "D. Port", "Seq #", "Ack", "Offset", "Reset", "Flags", "Window", "Check Sum", "Urgent Pointer"]
  pdf.table [[@event.tcphdr.tcp_sport, @event.tcphdr.tcp_dport, @event.tcphdr.tcp_seq, @event.tcphdr.tcp_ack, @event.tcphdr.tcp_off, @event.tcphdr.tcp_res, @event.tcphdr.tcp_flags, @event.tcphdr.tcp_win, @event.tcphdr.tcp_csum, @event.tcphdr.tcp_urp]],
  :headers => d_header,
  :header_color => 'f8f8f8',
  :header_text_color => "323233",
  :padding => 5,
  :border_style => :grid,
  :position => :center,
  :row_colors => ["FFFFFF", "e8f9ff"],
  :width => 535,
  :border_width => 1,
  :font_size => 9

  pdf.move_down(25)
end

unless @event.udphdr.blank?
  pdf.move_down(25)

  pdf.text "UDP Information:", :size => 15, :style => :bold, :align => :left
  c_header = ["Source Port", "Destination Port", "Length", "CheckSum"]
  pdf.table [[@event.udphdr.udp_sport, @event.udphdr.udp_dport, @event.udphdr.udp_len, @event.udphdr.udp_csum]],
  :headers => c_header,
  :header_color => 'f8f8f8',
  :header_text_color => "323233",
  :padding => 5,
  :border_style => :grid,
  :position => :center,
  :row_colors => ["FFFFFF", "e8f9ff"],
  :width => 535,
  :border_width => 1,
  :font_size => 9

  pdf.move_down(25)
end

unless @event.icmphdr.blank?
  pdf.move_down(25)

  pdf.text "ICMP Information:", :size => 15, :style => :bold, :align => :left
  f_header = ["Type", "Code", "CheckSum", "ID", "Sequence Number"]
  pdf.table [[@event.icmphdr.icmp_type, @event.icmphdr.icmp_code, @event.icmphdr.icmp_csum, @event.icmphdr.icmp_id, @event.icmphdr.icmp_seq]],
  :headers => f_header,
  :header_color => 'f8f8f8',
  :header_text_color => "323233",
  :padding => 5,
  :border_style => :grid,
  :position => :center,
  :row_colors => ["FFFFFF", "e8f9ff"],
  :width => 535,
  :border_width => 1,
  :font_size => 9

  pdf.move_down(25)
end

pdf.move_down(25)
