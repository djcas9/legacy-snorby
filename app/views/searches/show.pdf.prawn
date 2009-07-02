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

### Start Of Cover

pdf.move_down(100)
pdf.image snorby_logo, :scale=>0.7, :position => :center
pdf.text "Security Report", :size => 25, :style => :bold, :align => :center
pdf.text "This report was generated: #{Time.now.strftime('%A, %B %d, %Y')}", :size => 12, :style => :bold, :align => :center

pdf.move_down(30)
pdf.start_new_page

### End Table Of Contents

### GET DATA
high = []
medium = []
low = []
for event in @search.events
  low << event if event.sig.sig_priority == 3
  medium << event if event.sig.sig_priority == 2
  high << event if event.sig.sig_priority == 1
end
### END

### Summary

pdf.move_down(15)
pdf.text "Report Summary", :size => 20, :style => :bold, :align => :center
pdf.move_down(30)
header = ["Low Severity", "Medium Severity", "High Severity", "Total Event Count"]
pdf.table [[pluralize(low.size, "Event"), pluralize(medium.size, "Event"), pluralize(high.size, "Event"), pluralize(@search.events.size, "Event")]], 
  :headers => header,
  :position => :center,
  :border_width => 1,
  :font_size => 12
pdf.move_down(30)


pdf.start_new_page

### END

### Start Of Data

pdf.header [pdf.margin_box.left, pdf.margin_box.top + 20] do
  pdf.text "- #{Time.now.strftime('%A, %B %d, %Y')} - Snorby Report. -", :size => 7, :align => :center, :style => :italic, :color => 'black'
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

pdf.move_down(5)
pdf.text "Raw Event Data", :size => 20, :style => :bold, :align => :center

pdf.move_down(10)
h = 0
pdf.text "High Severity Events", :size => 15, :style => :bold, :align => :left
for event in high
  h += 1
  pdf.text "#{h}. #{event.sig.sig_name}", :style => :bold
  pdf.text "Source: #{IPAddr.new_ntoh([event.iphdr.ip_src].pack('N'))} - Destination: #{IPAddr.new_ntoh([event.iphdr.ip_dst].pack('N'))}"
  pdf.move_down(5)
end

pdf.move_down(10)
m = 0
pdf.text "Medium Severity Events", :size => 15, :style => :bold, :align => :left
for event in medium
  m += 1
  pdf.text "#{m}. #{event.sig.sig_name}", :style => :bold
  pdf.text "Source: #{IPAddr.new_ntoh([event.iphdr.ip_src].pack('N'))} - Destination: #{IPAddr.new_ntoh([event.iphdr.ip_dst].pack('N'))}"
  pdf.move_down(5)
end

pdf.move_down(10)
l = 0
pdf.text "Low Severity Events", :size => 15, :style => :bold, :align => :left
for event in low.uniq
  l += 1
  pdf.text "#{l}. #{event.sig.sig_name}", :style => :bold
  pdf.text "Source: #{IPAddr.new_ntoh([event.iphdr.ip_src].pack('N'))} - Destination: #{IPAddr.new_ntoh([event.iphdr.ip_dst].pack('N'))}"
  pdf.move_down(5)
end
### End Of Data
